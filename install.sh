#!/usr/bin/env bash

set -euf -o pipefail

OS=$(uname -s)

function install() {
  if [ "$OS" == "Darwin" ]; then
    brew install --quiet $@
  elif [ "$OS" == "Linux" ]; then
    sudo apt-get install -y $@
  else
    echo "Unsupported OS: $OS"
    exit 1
  fi
}

case "$OS" in
Darwin)
    if ! command -v brew &> /dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    install coreutils \
        unnaturalscrollwheels \
        awscli
    ;;
Linux)
    sudo apt-get update
    sudo snap install aws-cli --classic
    ;;
esac


install stow \
    zsh \
    bash \
    jq

stow -t "$HOME" -R common

case "$OS" in
Darwin)
    stow -t "$HOME/Library/Application Support" -R vscode
    ;;
Linux)
    stow -t "$HOME/.config" -R vscode
    chsh -s $(which zsh)
    ;;
esac
