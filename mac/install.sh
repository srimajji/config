#!/bin/bash

command -v brew >/dev/null 2>&1 || {
  echo >&2 "I require brew but it's not installed. \n .";
  exit 1;
}

# /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install mysql@5.6
brew install jenv
brew install nvm
brew install htop
brew install git-extras
brew install mas

nvm install 7.9.0 # set up node
mas install 425424353 # set up the unarchiver