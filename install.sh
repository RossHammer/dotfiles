#!/usr/bin/env bash

set -euf -o pipefail

cd "$(dirname "$0")"

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

function zsh_plugin() {
  TYPE=$1
  NAME=$2
  REPO=$3
  DIR="$HOME/.oh-my-zsh/custom/${TYPE}s/$NAME"
  if [ ! -d "$DIR" ]; then
    git clone "$REPO" "$DIR"
  else
    git -C "$DIR" pull
  fi
}

case "$OS" in
Darwin)
  if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  install coreutils \
    unnaturalscrollwheels \
    awscli \
    font-fira-code
  ;;
Linux)
  sudo apt-get update
  sudo snap install aws-cli --classic
  sudo apt-get install -y \
    fonts-firacode
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
  ;;
esac


install stow \
  zsh \
  bash \
  jq


if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
if ! command -v mise &> /dev/null; then
  curl https://mise.run | sh
fi
if ! command -v oh-my-posh &> /dev/null; then
   curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin
fi

stow -t "$HOME" -R common
zsh_plugin plugin zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions
zsh_plugin plugin zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git

case "$OS" in
Linux)
  if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s $(which zsh)
  fi
  ;;
esac
