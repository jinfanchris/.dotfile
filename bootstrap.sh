#!/bin/bash
# Copied from https://github.com/conanhujinming/dotfiles
########################
# This script creates symlinks from the home directory to any desired dotfiles in ~/.dotfiles

########## Variables
# install all the submodules

install_zsh() {
    # Test to see if zshell is installed.  If it is:
    if [ -f /bin/zsh ] || [ -f /usr/bin/zsh ]; then
        # Set the default shell to zsh if it isn't currently set to zsh
        echo "zsh having been installed!!!"
        if [ ! -d "$HOME/.oh-my-zsh" ]; then
            echo "install oh-my-zsh!!!"
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        fi
        if [ ! "$SHELL" == "$(which zsh)" ]; then
            chsh -s "$(which zsh)"
        fi
    else
        # If zsh isn't installed, get the platform of the current machine
        platform=$(uname)
        # If the platform is Linux, try an apt-get to install zsh and then recurse
        echo "installing zsh!!!"
        if [[ $platform == 'Linux' ]]; then
            if [[ -f /etc/redhat-release ]]; then
                sudo yum install zsh
                install_zsh
            fi
            if [[ -f /etc/debian_version ]]; then
                sudo apt-get install zsh
                install_zsh
            fi
        # If the platform is OS X, tell the user to install zsh :)
        elif [[ $platform == 'Darwin' ]]; then
            echo "Please install zsh, then re-run this script!"
            exit
        fi
    fi
}
install_zsh

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" # dotfiles directory
olddir=~/.dotfiles_old                              # old dotfiles backup directory
echo "$dir"
ZSH_CUSTOM_PLUG="oh-my-zsh/custom/plugins"
ZSH_CUSTOM_THEME="oh-my-zsh/custom/themes"
ZSH_PLUG="$ZSH_CUSTOM_PLUG/autojump $ZSH_CUSTOM_PLUG/zsh-autosuggestions $ZSH_CUSTOM_PLUG/zsh-completions $ZSH_CUSTOM_PLUG/zsh-syntax-highlighting $ZSH_CUSTOM_PLUG/zsh-history-substring-search $ZSH_CUSTOM_PLUG/zsh-git-prompt "
ZSH_THEME="$ZSH_CUSTOM_THEME/powerlevel10k "
submodules="fzf tmux "$ZSH_PLUG$ZSH_THEME

for file in $submodules; do
    echo "$file"
    git submodule update --init "$file"
done

files="bashrc bash_profile vimrc vim zshrc gitconfig gitignore_global export aliases fzf tmux tmux.config.local p10k.zsh "$ZSH_PLUG

# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd "$dir" || exit
echo "done"

for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv ~/."$file" $olddir/
    echo "Creating symlink to $file in home directory."
    ln -fns "$dir"/"$file" ~/."$file"
done

# create symlink for tmux config
ln -fns ~/.tmux/.tmux.conf ~/.tmux.conf

cd "$ZSH_CUSTOM_PLUG/autojump" || exit
./install.py

~/.fzf/install

ln -sfn "$dir/oh-my-zsh/custom/themes/powerlevel10k" ~/.oh-my-zsh/custom/themes/powerlevel10k

mkdir -p "~/.vim/udir"
mkdir -p "~/.vim/bdir"

rm ~/.zcompdump*
