# Dot Files

Dot files (.zshrc, .gitconfig, etc.)

## Directories

- [.config](#config) - Top level config directory (gh, ghostty, nvim, etc.)
- [.azure](#azure) - Top level config for Azure configs

## Configs

- [.digrc](.digrc) - [https://en.wikipedia.org/wiki/Dig_(command)](dig) BIND dig config
- [.zshrc](.zshrc) - Z shell config
- [.gitconfig](.gitconfig) - Git command config (alias, options, etc.)

### .config

- [ghostty/config](.config/ghostty/config) - Ghostty config
- [gh/config.yml](.config/gh/config.yml) - GitHub CLI config
- [lazygit/config.yml](.config/lazygit/config.yml) - lazygit config

### .azure

- [config](.azure/config) - Azure CLI config

## Script

Use shell script `symup.sh` to scan home directory dot files and link to repository provided files.
