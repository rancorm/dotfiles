# Dotfiles

Dot configuration files (.zshrc, .gitconfig, etc.)

## Directories

- [.config](#config) - Top level config directory (gh, ghostty, nvim, etc.)
- [.azure](#azure) - Top level config for Azure configs

## Configs

- [.digrc](.digrc) - [https://en.wikipedia.org/wiki/Dig_(command)](dig) BIND dig
- [.zshrc](.zshrc) - Z shell
- [.gitconfig](.gitconfig) - Git command (options, etc.)
- [.gitconfig.aliases](.gitconfig.aliases) - Git aliases

### .config/

- [ghostty/config](.config/ghostty/config) - Ghostty 
- [gh/config.yml](.config/gh/config.yml) - GitHub CLI
- [lazygit/config.yml](.config/lazygit/config.yml) - lazygit
- [nvim/init.lua](.config/nvim/init.lua) - Neovim
- [wezterm/wezterm.lua](.config/wezterm/wezterm.lua) - WezTerm

### .azure

- [config](.azure/config) - Azure CLI

## Script

Use shell script `symup.sh` to scan home directory dot files and link to repository provided files.
