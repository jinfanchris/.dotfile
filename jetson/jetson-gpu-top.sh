#!/usr/bin/env bash
# Simple "nvidia-smi-like" GPU monitor for Jetson (Nano / Orin / Xavier)
# Shows GPU load, frequency and GPU clients (processes using the GPU).

set -euo pipefail

# ---------- Paths (针对你现在这台 nano06 的 JP6/Orin Nano 风格) ----------
GPU_LOAD_PATH="/sys/devices/platform/bus@0/17000000.gpu/load"
GPU_FREQ_PATH="/sys/devices/platform/bus@0/17000000.gpu/devfreq/17000000.gpu/cur_freq"

# 可能的 DRM clients 文件（不同板子可能略有差异）
POSSIBLE_DRI_CLIENTS_FILES=(
    "/sys/kernel/debug/dri/0/clients"
    "/sys/kernel/debug/dri/128/clients"
)

# ---------- Helper: 检查文件是否存在 ----------
check_file() {
    local path="$1"
    if [[ ! -r "$path" ]]; then
        echo "WARN: Cannot read $path" >&2
        return 1
    fi
    return 0
}

# ---------- Helper: 选择一个可用的 clients 文件 ----------
pick_dri_clients_file() {
    for f in "${POSSIBLE_DRI_CLIENTS_FILES[@]}"; do
        if [[ -r "$f" ]]; then
            echo "$f"
            return 0
        fi
    done
    # 如果一个都找不到
    echo ""
    return 1
}

# ---------- Decide sudo usage ----------
SUDO=""
if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
    SUDO="sudo"
fi

# ---------- Sanity checks ----------
if ! check_file "$GPU_LOAD_PATH"; then
    echo "ERROR: GPU load file not found: $GPU_LOAD_PATH"
    exit 1
fi

if ! check_file "$GPU_FREQ_PATH"; then
    echo "ERROR: GPU frequency file not found: $GPU_FREQ_PATH"
    exit 1
fi

DRI_CLIENTS_FILE="$(pick_dri_clients_file || true)"

if [[ -z "$DRI_CLIENTS_FILE" ]]; then
    echo "WARN: No readable /sys/kernel/debug/dri/*/clients file found."
    echo "      GPU clients will NOT be shown. Run as root and check debugfs is mounted."
fi

# ---------- 主循环 ----------
INTERVAL="${1:-1}" # 可选参数：刷新间隔秒数，默认 1s

while true; do
    clear
    NOW="$(date '+%Y-%m-%d %H:%M:%S')"

    # GPU load
    RAW_LOAD="$(cat "$GPU_LOAD_PATH" 2>/dev/null || echo 0)"
    # RAW_LOAD 是 0 ~ 1000，表示 0.0% ~ 100.0%
    GPU_LOAD_PERCENT=$((RAW_LOAD / 10))

    # GPU freq (Hz -> MHz)
    RAW_FREQ="$(cat "$GPU_FREQ_PATH" 2>/dev/null || echo 0)"
    GPU_FREQ_MHZ=$((RAW_FREQ / 1000000))

    echo "================ Jetson GPU Monitor ================"
    echo "Time      : $NOW"
    echo "GPU Load  : ${GPU_LOAD_PERCENT}% (raw: ${RAW_LOAD}/1000)"
    echo "GPU Freq  : ${GPU_FREQ_MHZ} MHz (raw: ${RAW_FREQ} Hz)"
    echo

    # 显示 GPU clients
    if [[ -n "$DRI_CLIENTS_FILE" ]]; then
        echo "GPU Clients (excluding Xorg / gnome-shell):"
        echo "-------------------------------------------"

        # 头一行原样打印，其它行过滤掉 Xorg / gnome-shell
        $SUDO cat "$DRI_CLIENTS_FILE" 2>/dev/null |
            awk 'NR==1 || ($1!="Xorg" && $1!="gnome-shell")'

        echo
        echo "(raw clients from: $DRI_CLIENTS_FILE)"
    else
        echo "GPU Clients: unavailable (no dri/*/clients found)"
    fi

    echo "===================================================="
    echo "Press Ctrl-C to quit. Refresh interval: ${INTERVAL}s"

    sleep "$INTERVAL"
done
