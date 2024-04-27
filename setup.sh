#!/bin/bash
set -e

pushd ~
USER_DIR=$(pwd)
popd
CONFIG_DIR=configs
function prompt_question() {
    if [ $1 ]
    then
        read -p "$2 already installed, would you like to re-configure $2? (Y - yes, N - no)  " answer
    else
        answer="Y"
    fi
}

function install_neovmim() {
  local CONFIG_DIR=${USER_DIR}/.config/nvim

  mkdir -p $CONFIG_DIR
  git clone git@github.com:royeilam/neovimconfig.git $CONFIG_DIR
}

function install_oh_my_zsh() {
    if [ -d ${USER_DIR}/.oh-my-zsh ]
    then
        rm -rf ${USER_DIR}/.oh-my-zsh
    fi

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    sed -i "s/^ZSH_THEME.*/ZSH_THEME=\"agnoster\"/" ${USER_DIR}/.zshrc
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    sed -i "s/plugins=(\(.*\))/plugins=(\1 zsh-autosuggestions zsh-syntax-highlighting)/g" ${USER_DIR}/.zshrc
    chsh -s $(which zsh)
}

# Insalling necessary apps
APP_LIST="neovim tmux curl python3 exuberant-ctags zsh git fonts-powerline nodejs npm fzf ripgrep"

sudo apt update
sudo apt upgrade
sudo apt -y install $APP_LIST

# Configure neovim
prompt_question "-d ${USER_DIR}/.config/nvim" "NEOVIM"

if [ "$answer" == "Y" ]
then
    install_neovmim
fi

#Configure Zshell
prompt_question "-d ${USER_DIR}/.oh-my-zsh" "OH-MY_ZSHELL"

if [ $answer == "Y" ]
then
  install_oh_my_zsh
fi
