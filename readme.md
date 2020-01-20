# Jesse Reitz Dotfiles

My bash and vim setup

## Initial installation configuration
1. `git clone https://github.com/jessereitz/.dotfiles`
2. `echo "source $HOME/.dotfiles/main_config.sh >> .bashrc`
    * for mac: `echo "source $HOME/.dotfiles/main_config.sh >> .bash_profile`
3. Start a new shell
4. `initialize_all`

### Copy & Paste
```bash
unameOut="$(uname -s)" &&
case "${unameOut}" in
    Linux*)     config_file=~/.bashrc;;
    Darwin*)    config_file=~/.bash_profile;;
    *)          echo "unkown OS" && exit;;
esac &&
git clone git@github.com:jessereitz/.dotfiles &&
echo "source $HOME/.dotfiles/main_config.sh" >> $config_file &&
source $config_file &&
initialize_all
```
