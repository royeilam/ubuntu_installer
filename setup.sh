#!/bin/bash
set -x

USER_DIR=~
CONFIG_DIR=configs
function prompt_question()
{
    if [ $1 ]
    then
        read -p "$2 already installed, would you like to re-configure $2? (Y - yes, N - no)  " answer
    else
        answer="Y"
    fi
}

# Insalling necessary apps
APP_LIST="vim tmux curl python3 exuberant-ctags zsh git fonts-powerline"

sudo apt update
sudo apt upgrade
sudo apt -y install $APP_LIST

# Configure vim
prompt_question "-e $USER_DIR/.vimrc" "VIM"

if [ "$answer" == "Y" ]
then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    VIM_THEME_DIR=$USER_DIR/.vim/colors
    mkdir -p $VIM_THEME_DIR
    cp -f $CONFIG_DIR/vim/codedark.vim $VIM_THEME_DIR/codedark.vim
    cp -f $CONFIG_DIR/vim/vimrc $USER_DIR/.vimrc
fi

#Configure Zshell
prompt_question "-d $USER_DIR/.oh-my-zsh" "OH-MY_ZSHELL"

if [ $answer == "Y" ]
then
    if [ -d $USER_DIR/.oh-my-zsh ]
    then
        rm -rf $USER_DIR/.oh-my-zsh
    fi

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    sed -i "s/^ZSH_THEME.*/ZSH_THEME=\"agnoster\"/" $USER_DIR/.zshrc
fi

set +x
