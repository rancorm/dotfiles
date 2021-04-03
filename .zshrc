#
# Jonathan Cormier Zsh Profile
#
# Notes:
#

## Oh My Zsh
#
# Path to your oh-my-zsh installation
export ZSH="/Users/jonathan/.oh-my-zsh"

# Theme
ZSH_THEME="apple"

# History command date format.
# You can set one of the optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="dd.mm.yyyy"

# Standard plugins: ~/.oh-my-zsh/plugins/
# Custom plugins: ~/.oh-my-zsh/custom/plugins/
#
# git clone https://github.com/zsh-users/{zsh-autosuggestions,zsh-syntax-highlighting}
#
plugins=(
  git
  osx
  brew
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

## App intergrations
#
# iTerm2
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Secretive - SSH agent
export SSH_AUTH_SOCK=${HOME}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh

## Functions
#
# Fetch gitignore.io profile via API 
function gi() { curl -sLw n https://www.gitignore.io/api/$@ ;}

## User configuration
#
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Command aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias code="codium"
alias tf="terraform"

# Add user directories to PATH 
# User and brew 
export PATH=~/bin:~/.cargo/bin:$PATH
# Go 
export PaTH=~/go/bin:$PATH

# ZSH prompt (if found)
if [[ -f ~/.zsh_prompt ]]; then
  . ~/.zsh_prompt
fi
