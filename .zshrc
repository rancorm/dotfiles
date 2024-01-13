#
# Jonathan Cormier Zsh Profile
#
# Notes:
#
# Oh-My-Zsh
# App intergrations
#  Secretive
# User functions and settings

## Oh My Zsh
#
# Path to your oh-my-zsh installation
export ZSH=$HOME"/.oh-my-zsh"

# Theme
ZSH_THEME="clean"

# History command date format.
# You can set one of the optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="dd.mm.yyyy"

# Standard plugins: ~/.oh-my-zsh/plugins/
# Custom plugins: ~/.oh-my-zsh/custom/plugins/
#
# https://github.com/zsh-users/{zsh-autosuggestions,zsh-syntax-highlighting}
#
plugins=(
  xcode
  kubectl
  vscode
  terraform
  httpie
  gitignore
  git
  macos
  brew
  docker
  docker-compose
  aws
  gh
  pip
  virtualenv
#  zsh-autosuggestions
#  zsh-syntax-highlighting
)

# Init Oh My Zsh framework
source $ZSH/oh-my-zsh.sh

## App intergrations
#
# Secretive - SSH agent
export SSH_AUTH_SOCK=${HOME}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh

## Functions
#
# Convert CloudFormation parameter file to CodePipeline template style
function cf2cp() {
  jq '{ Parameters: [ .[] | { (.ParameterKey): .ParameterValue } ] | add }' < $@;
}

function lolbanner {
  figlet -c -f ~/.local/share/fonts/figlet-fonts/3d.flf $@ | lolcat
}

## User configuration
#
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Disable paste highlighting
zle_highlight=('paste:none')

# Command aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias tf="terraform"
alias zhist="history -i"
alias cdp="cd ~/Projects"
alias dy="dig +short @dns.toys"
alias nv="nvim"

# Add user directories to PATH. Local bin, Brew, and Pip
export PATH="/usr/local/sbin:${HOME}/bin:${HOME}/.cargo/bin:${HOME}/.local/bin:$PATH"

# Go 
export PATH="${HOME}/go/bin:$PATH"

# Krew - https://krew.sigs.k8s.io/docs/user-guide/setup/install/
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Ghidra
export PATH="/opt/ghidra:$PATH"

# Zsh prompt (if found)
if [[ -f ~/.zsh_prompt ]]; then
  . ~/.zsh_prompt
fi
