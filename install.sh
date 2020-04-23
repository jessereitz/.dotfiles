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
OS_ENV="$(uname -s)"

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
    echo "Installing dotfiles..."
    dotfiles_dir=$HOME/.dotfiles
    dotfiles_repo=https://github.com/jessereitz/.dotfiles

    case "${OS_ENV}" in
        Linux*)     config_file=~/.bashrc;;
        Darwin*)    config_file=~/.bash_profile;;
        *)          echo "unkown OS" && exit;;
    esac &&
    echo $unameOut

    use_hub=$1
    if [ $use_hub ]; then
        echo "Using hub"
        git config --global hub.protocol https
        hub clone $dotfiles_repo $dotfiles_dir
    else
        echo "Using git with https"
        git clone $dotfiles_repo $dotfiles_dir
    fi
    echo $config_file
    echo "source $HOME/.dotfiles/main_config.sh" >> $config_file &&
    source $config_file &&
    initialize_all
}

function install_brew_and_packages {
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    if [ $OS_ENV == 'Linux' ]; then
        test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
        test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
        test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bashrc
        echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bashrc
    fi
    echo "Installing apps..."
    curl -o /tmp/Brewfile https://gist.githubusercontent.com/jessereitz/a6f0c8ccc0741b224a64c14368a9b92c/raw/ &&
    brew bundle --file /tmp/Brewfile
    echo "Homebrew and apps installed."
}

function install_prereqs {
    echo "Installing prerequisite packages..."
    if [ $OS_ENV == "Linux" ]; then
        sudo apt-get install git curl build-essential -y
    elif [ $OS_ENV == "Darwin" ]; then
        xcode-select --install
    fi
    echo "All prerequisite packages installed."
}


if [ $COMPLETE_INSTALL = true ]; then
    install_brew_and_packages
    install_dotfiles -h
else
    install_dotfiles
fi
