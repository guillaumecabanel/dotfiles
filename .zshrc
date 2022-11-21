export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="guillaumecabanel"

plugins=(git gitfast common-aliases last-working-dir zsh-syntax-highlighting ssh-agent)

# ssh-agent settings
zstyle :omz:plugins:ssh-agent identities clevercloud gitlab id_ed25519

source $ZSH/oh-my-zsh.sh

# User configuration

# bin
export PATH="./bin:${PATH}:/usr/local/sbin:${HOME}/.local/bin"

# rbenv
export PATH="${HOME}/.rbenv/bin:${PATH}"
type -a rbenv > /dev/null && eval "$(rbenv init -)"

# aliases
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
