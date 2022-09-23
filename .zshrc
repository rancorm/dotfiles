#
# Jonathan Cormier Zsh Profile
#
# Notes:
#
# Oh-My-Zsh
# App intergrations
#  iTerm2 intergration
#  Secretive
# User functions and settings

## Oh My Zsh
#
# Path to your oh-my-zsh installation
export ZSH="/Users/jonathan/.oh-my-zsh"

# Theme
ZSH_THEME="cypher"

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
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Init Oh My Zsh framework
source $ZSH/oh-my-zsh.sh

## App intergrations
#
# iTerm2
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

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

# Command aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias code="codium"
alias tf="terraform"
alias zhist="history -i"
alias cdp="cd ~/Projects"

# Add user directories to PATH 
# User, brew, and pip user paths
export PATH="${HOME}/bin:${HOME}/.cargo/bin:${HOME}/.local/bin:$PATH"
# Go 
export PATH="${HOME}/go/bin:$PATH"
# Krew - https://krew.sigs.k8s.io/docs/user-guide/setup/install/
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Zsh prompt (if found)
if [[ -f ~/.zsh_prompt ]]; then
  . ~/.zsh_prompt
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/jonathan/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/jonathan/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/jonathan/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/jonathan/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Starship Prompt
eval "$(starship init zsh)"
