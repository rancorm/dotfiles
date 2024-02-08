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

## Functions
#
# Convert CloudFormation parameter file to CodePipeline template style
function cf2cp() {
  jq '{ Parameters: [ .[] | { (.ParameterKey): .ParameterValue } ] | add }' < $@;
}

function lolbanner {
  figlet -c -f ~/.local/share/fonts/figlet-fonts/3d.flf $@ | lolcat
}

function custom_plugin() {
    local plugin_name="$1"
    local zsh_plugins_dir="$ZSH/custom/plugins"

    # Check if the plugin directory exists
    if [ -d "$zsh_plugins_dir/$plugin_name" ]; then
	echo $plugin_name
    fi
}

## Oh My Zsh 
#
# Standard plugins: ~/.oh-my-zsh/plugins/
# Custom plugins: ~/.oh-my-zsh/custom/plugins/
#
plugins=(
  autoenv
  screen
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
)

plugins+=($(custom_plugin "zsh-completions"))
plugins+=($(custom_plugin "zsh-autosuggestions"))
plugins+=($(custom_plugin "zsh-syntax-highlighting"))

source $ZSH/oh-my-zsh.sh

## App intergrations
#
# Secretive - SSH agent
export SSH_AUTH_SOCK=${HOME}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh

## User configuration
#
# Prevent session saving
export SHELL_SESSIONS_DISABLE=1

export AUTOENV_ENABLE_LEAVE=1

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
alias canopy="tree -t --dirsfirst -I __pycache__"
alias clearcreds="unset AWS_CREDENTIAL_EXPIRATION \
  AWS_ACCESS_KEY_ID \
  AWS_SECRET_ACCESS_KEY \
  AWS_SESSION_TOKEN \
  AWS_ENDPOINT_URL \
  AWS_PROFILE \
  AWS_VAULT \
  && echo 'AWS credentials cleared'"
alias k="kubectl"
alias c="cargo"

# Add user directories to PATH. Local bin, Brew, and Pip
export PATH="/usr/local/sbin:${HOME}/bin:${HOME}/.cargo/bin:${HOME}/.local/bin:$PATH"

# Go - https://golang.org/doc/install
export PATH="${HOME}/go/bin:$PATH"

# Krew - https://krew.sigs.k8s.io/docs/user-guide/setup/install/
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Ghidra - https://ghidra-sre.org/
export PATH="/opt/ghidra:$PATH"

# Zsh prompt (if found)
if [[ -f ~/.zsh_prompt ]]; then
  . ~/.zsh_prompt
fi
