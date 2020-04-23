#!/usr/bin/env bash

echo
echo "########################"
echo "#                      #"
echo "#   ReReitz Dotfiles   #"
echo "#                      #"
echo "########################"
echo

echo "This script will install ReReitz dotfiles into $HOME/.dotfiles"
echo

COMPLETE_INSTALL=false

echo "Please select an installation type:"
echo -e "\t 1) Dotfiles only (clone via https, set up bash and vim)"
echo -e "\t 2) Complete Install (clone via hub, set up bash and vim)"
echo
read -p "Select an option  (Default: 1) " -r
if [[ $REPLY =~ ^[2]$ ]]; then
    COMPLETE_INSTALL=true
fi

echo $COMPLETE_INSTALL

function install_dotfiles {
    dotfiles_dir=$HOME/.dotfiles
    dotfiles_repo=https://github.com/jessereitz/.dotfiles

    unameOut="$(uname -s)" &&
    case "${unameOut}" in
        Linux*)     config_file=~/.bashrc;;
        Darwin*)    config_file=~/.bash_profile;;
        *)          echo "unkown OS" && exit;;
    esac &&

    use_hub=$1
    if [ $use_hub ]; then
        echo "Using hub"
        git config --global hub.protocol https
        hub clone $dotfiles_repo $dotfiles_dir
    else
        echo "Using git with https"
        git clone $dotfiles_repo $dotfiles_dir
    fi
    echo "source $HOME/.dotfiles/main_config.sh" >> $config_file &&
    source $config_file &&
    initialize_all
}

function install_everything {
    OS_ENV="$(uname -s)" &&
    if [ $OS_ENV == "Linux" ]; then
        sudo apt-get install build-essential -y
        homebrew_prefix=/home/linuxbrew/.linuxbrew
    elif [ $OS_ENV == "Darwin" ]; then
        homebrew_prefix=/usr/local
    else
        echo "unkown OS" && exit
    fi

    homebrew_exec=$homebrew_prefix/bin/brew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" &&
    curl -o /tmp/Brewfile https://gist.githubusercontent.com/jessereitz/a6f0c8ccc0741b224a64c14368a9b92c/raw/ &&
    test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
    test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bashrc
    echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bashrc

    brew bundle --file /tmp/Brewfile &&
    install_dotfiles -h
}


if [ $COMPLETE_INSTALL = true ]; then
    install_everything
else
    install_dotfiles
fi
