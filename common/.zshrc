PATH=~/.local/bin:~/bin:~/go/bin:$PATH
# eval "$($HOME/.local/bin/mise activate zsh)"

export ZSH="$HOME/.oh-my-zsh"
plugins=(history zsh-autosuggestions command-not-found aws docker zsh-syntax-highlighting mise)
source $ZSH/oh-my-zsh.sh

eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh.yml)"


if [[ "$OSTYPE" != "darwin"* ]]; then
	alias pbcopy='xsel --clipboard --input'
	alias pbpaste='xsel --clipboard --output'
fi


# export PATH="$HOME/.poetry/bin:$PATH"
export AWS_SDK_LOAD_CONFIG=1
