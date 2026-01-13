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
ZSH_THEME="nothing"

NT_HIDE_EXIT_CODE=1
NT_HIDE_COUNT=1

# History command date format.
# You can set one of the optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="dd.mm.yyyy"

set clipboard += unnamedplus

## Functions
#
# Convert CloudFormation parameter file to CodePipeline template style
function cf2cp {
  jq '{ Parameters: [ .[] | { (.ParameterKey): .ParameterValue } ] | add }' < $@;
}

function lolbanner {
  figlet -c -f ~/.local/share/fonts/figlet-fonts/3d.flf $@ | lolcat
}

function custom_plugin {
    local plugin_name="$1"
    local zsh_plugins_dir="$ZSH/custom/plugins"

    # Check if the plugin directory exists
    if [ -d "$zsh_plugins_dir/$plugin_name" ]; then
	echo $plugin_name
    fi
}

function cdp {
  local target="$HOME/Projects/${1:-}"
  
  if [[ -d "$target" ]]; then
    cd "$target"
  else
    echo "Directory does not exist: $target"
  fi
}

function _bwsid() {
  BW_SESSION=$(bw unlock --raw) && \
  PUBKEY=$(bw get item "$1" --session $BW_SESSION | jq -r ".notes") && \
  ssh-copy-id -i <(echo "$PUBKEY") "${2:-user@hostname}"
}

## Oh My Zsh 
#
# Standard plugins: ~/.oh-my-zsh/plugins/
# Custom plugins: ~/.oh-my-zsh/custom/plugins/
#
plugins=(
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
  aws
  gh
  pip
  virtualenv
  azure
)

plugins+=($(custom_plugin "zsh-completions"))
plugins+=($(custom_plugin "zsh-autosuggestions"))
plugins+=($(custom_plugin "zsh-syntax-highlighting"))

source $ZSH/oh-my-zsh.sh

# Disable paste highlighting
zle_highlight=('paste:none')

## App intergrations
#
# Bitwarden SSH agent
export SSH_AUTH_SOCK=${HOME}/.bitwarden-ssh-agent.sock

## User configuration
#
# Prevent session saving
export SHELL_SESSIONS_DISABLE=1
export AUTOENV_ENABLE_LEAVE=1

# GitHub CLI glamour style
export GLAMOUR_STYLE="tokyo-night"

## Path
#
# Add user directories to PATH. Local bin, Brew, and Pip
export PATH="/usr/local/sbin:$HOME/bin:$HOME/.cargo/bin:$HOME/.local/bin:$PATH"
export PATH="~/bin:$PATH"

# Brew Python
if command -v brew &> /dev/null; then
  BREW_PREFIX=$(brew --prefix python)
  export PATH="$BREW_PREFIX/libexec/bin":$PATH
fi

# Go - https://golang.org/doc/install
export PATH="$HOME/go/bin:$PATH"

# Krew - https://krew.sigs.k8s.io/docs/user-guide/setup/install/
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Ghidra - https://ghidra-sre.org/
export PATH="/opt/ghidra:$PATH"

# Modular
export MODULAR_HOME="/Users/jonathan/.modular"
export PATH="/Users/jonathan/.modular/pkg/packages.modular.com_mojo/bin:$PATH"

# Mason
export PATH="$HOME/.local/share/nvim/mason/bin":$PATH

# Zsh prompt (if found)
if [[ -f ~/.zsh_prompt ]]; then
  . ~/.zsh_prompt
fi

# Fix for xterm-ghostty unknown terminal type
export TERM=xterm-256color

source ~/.zshrc.aliases
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
