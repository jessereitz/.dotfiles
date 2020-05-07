#!/bin/sh
######################################################################
# Install script for Jesse R's dotfiles:
#
# Usage:
#    wget > blah blah
#
#     https://github.com/jessereitz/.dotfiles
#
######################################################################
printf "\n\n#######################################\n\n"
echo "          Installing Dotfiles          "
printf "\n#######################################\n\n\n"

clone_repo() {
    echo "Cloning jessereitz/.dotfiles"
    git clone https://github.com/jessereitz/.dotfiles || echo "😬 Unable to clone jessereitz/.dotfiles"; exit 1
    echo "👍 jessereitz/.dotfiles cloned successfully"
}

detect_OS() {
    echo "Determining which OS you're using..."
    OS_ENV="$(uname -s)" &&
    case "$OS_ENV" in
        Linux*)     config_file=~/.bashrc;;
        Darwin*)    config_file=~/.bash_profile;;
        *)          echo "unkown OS" && exit;;
    esac

    echo "Detected $OS_ENV, using config file $config_file"
}

configure_git() {
    echo "⚙︎ Setting global gitconfig"
    if [ -f ~/.gitconfig ]; then
        echo "There is already a gitconfig present. Backing it up to ~/.gitconfig.bak"
        mv ~/.gitconfig ~/.gitconfig.bak
    fi

    if [ -f ~/.gitignore_global ]; then
        echo "There is already a global gitignore present. Backing it up to ~/.gitignore_global.bak"
        mv ~/.gitignore_global ~/.gitignore_global.bak
    fi

    echo "🔗 Linking global gitconfig"
    ln -s "$BASH_CONFIG"/.gitconfig ~/.gitconfig
    echo "🔗 Linking global gitignore"
    ln -s "$BASH_CONFIG"/.gitignore_global ~/.gitignore_global
    echo "👍 Done linking global git configurations"
}

setup_vim() {
    echo "⚙︎ Initializing vim"
    vim_installed=true
    command -v vim || vim_installed=false

    if [ "$vim_installed" = false ] && [ "$OS_ENV" = "Linux" ]; then
        echo "Vim is not installed. Installing..."
        sudo apt-get update &&
        sudo apt-get install vim-gnome
        echo "😀 Vim is now installed."
    elif [ "$vim_installed" = false ]; then
        echo "😬 Vim is not installed. I dunno what to do about it."
        exit 1
    fi

    if [ -d ~/.vim ]; then
        echo "There is already a ~/.vim config dir. Backing it up to ~/.vim.bak"
        mv ~/.vim ~/.vim.bak
    fi

    echo "🔗 Linking vim config"
    ln -s "$BASH_CONFIG"/.vim ~/.vim
    echo "🔌 Installing vim plugins"
    vim +PlugInstall +qall
    echo "👍 Done initializing vim"
}

source_config() {
    main_config=".dotfiles/main_config.sh"
    echo "⛲️ Sourcing main config $main_config in config file $config_file"
    echo "source $HOME/$main_config" >> "$config_file"
    echo "👍 Done."

    echo "⛲️ Sourcing config file $config_file for current shell"
    # shellcheck source=/dev/null
    . "$config_file"
    echo "👍 Done."
}

echo "⏱ Configuring dotfiles..."
clone_repo &&
detect_OS &&
configure_git &&
setup_vim &&
source_config &&
echo "🎉😁 All dotfiles configured."
