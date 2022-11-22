#!/bin/bash
set -x

pushd ~
USER_DIR=$(pwd)
popd
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

function run_command()
{
	$@
	if [ $? -ne 0 ]
	then
		echo "Cannot execute $@"
		exit 1
	fi
}

# Insalling necessary apps
APP_LIST="neovim tmux curl python3 exuberant-ctags zsh git fonts-powerline nodejs npm fzf ripgrep"

run_command sudo apt update
run_command sudo apt upgrade
run_command sudo apt -y install $APP_LIST

# Configure neovim
prompt_question "-d ${USER_DIR}/.config/nvim" "NEOVIM"

if [ "$answer" == "Y" ]
then
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

    run_command mkdir -p ${USER_DIR}/.config/nvim
    run_command cp -f ${CONFIG_DIR}/nvim/init.vim ${USER_DIR}/.config/nvim/
    run_command nvim +PlugInstall +qall
    # Installing CoC
    pushd ${USER_DIR}/.config/nvim/plugged/coc.nvim
    # Installing YARN
    run_command sudo npm install -g yarn
    run_command yarn install
    run_command yarn build
    popd
    run_command nvim +"CocInstall coc-pyright" +qa
    run_command nvim +"CocInstall coc-clangd" +qa

fi

#Configure Zshell
prompt_question "-d ${USER_DIR}/.oh-my-zsh" "OH-MY_ZSHELL"

if [ $answer == "Y" ]
then
    if [ -d ${USER_DIR}/.oh-my-zsh ]
    then
        rm -rf ${USER_DIR}/.oh-my-zsh
    fi

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    sed -i "s/^ZSH_THEME.*/ZSH_THEME=\"agnoster\"/" ${USER_DIR}/.zshrc
    run_command git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    run_command git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    sed -i "s/plugins=(\(.*\))/plugins=(\1 zsh-autosuggestions zsh-syntax-highlighting)/g" ${USER_DIR}/.zshrc
    chsh -s $(which zsh)

fi

set +x
