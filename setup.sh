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

function run_command()
{
	$1
	if [ $? -ne 0 ]
	then
		echo "Cannot execute $1"
		exit 1
	fi
}

# Insalling necessary apps
APP_LIST="vim tmux curl python3 exuberant-ctags zsh git fonts-powerline"

run_command "sudo apt update"
run_command "sudo apt upgrade"
run_command "sudo apt -y install $APP_LIST"

# Configure vim
prompt_question "-e $USER_DIR/.vimrc" "VIM"

if [ "$answer" == "Y" ]
then
    VIM_THEME_DIR=$USER_DIR/.vim/colors
    mkdir -p $VIM_THEME_DIR
    cp -f $CONFIG_DIR/vim/codedark.vim $VIM_THEME_DIR/codedark.vim
    cp -f $CONFIG_DIR/vim/vimrc $USER_DIR/.vimrc
    run_command "git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim"
    run_command "vim +PlugInstall +qall"

    # Installing YouCompleteMe
    #run_command "pushd $USER_DIR/.vim/plugged/YouCompleteMe"
    #run_command "sudo apt install -y build-essential cmake vim-nox python3-dev"
    #run_command "sudo apt install -y mono-complete golang nodejs default-jdk npm"
    #run_command "python3 install.py --all"
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
    chsh -s $(which zsh)
fi

set +x
