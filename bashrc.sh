source ~/.bash_settings/variables.sh
source ~/.bash_settings/functions.sh
source ~/.bash_settings/aliases.sh
source ~/.bash_settings/colors.sh
if [ -f ~/bonnie/bonnie.sh ]; then
  source ~/bonnie/bonnie.sh
fi

if [ -f ~/.bash_settings/git-completion.bash ]; then
  . ~/.bash_settings/git-completion.bash
fi

if [ -f ~/.bash_settings/git-prompt.sh ]; then
  . ~/.bash_settings/git-prompt.sh
fi