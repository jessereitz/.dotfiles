unameOut="$(uname -s)"
case "${unameOut}" in
  Linux*)     OS_ENV=Linux;;
  Darwin*)    OS_ENV=Mac;;
  *)          OS_ENV="UNKNOWN:${unameOut}";;
esac
export OS_ENV=$OS_ENV
