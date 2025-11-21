# #  You can profile the execution speed with this, and zprof at the bottom
# zmodload zsh/zprof
#
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
source ~/.bash_profile
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"
# ZSH_THEME="aussiegeek"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=13

plugins=(
		git
		python
		vi-mode
		z
		sudo
		zsh-syntax-highlighting
		zsh-autosuggestions
		zsh-history-substring-search
		zsh-completions
)

source $ZSH/oh-my-zsh.sh

[ -f ~/.zshrc_local ] && source ~/.zshrc_local
[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/.export ] && source ~/.export

AUTOJUMP="$ZSH/custom/plugins/autojump"
if [[ ! -d ~/.autojump ]] {
	echo "autojump not installed!!!"
}

[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && source ~/.autojump/etc/profile.d/autojump.sh
autoload -U compinit && compinit -u
if [[ ! -d $HOME/.fzf ]] {
	echo "fzf not installed!!!"
}

# export CLICOLOR=1
# export TERM=xterm-256color

bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line

[[ ! -f ~/.fzf.zsh ]] || source ~/.fzf.zsh

# source "$ZSH/custom/plugins/zsh-git-prompt/zshrc.sh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
#

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# zprof
