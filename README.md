# Personal Neovim Configuration

## Introduction

This is a personalized Neovim configuration based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).

**Base**: Built on kickstart.nvim foundation
**Status**: Personal fork with custom modifications and plugins

## Personal Customizations

### Key Differences from Kickstart
- Extended plugin ecosystem in `lua/custom/plugins/` including navigation, productivity, and database tools
- AI-assisted code completion
- Personal keybindings and workflow optimizations
- Specialized tools for note-taking and reference management

## Dependencies

Same as kickstart.nvim:
- Basic utils: `git`, `make`, `unzip`, C Compiler (`gcc`)
- [ripgrep](https://github.com/BurntSushi/ripgrep#installation), [fd-find](https://github.com/sharkdp/fd#installation)
- Clipboard tool (`wl-clipboard` for Wayland, `xclip`/`xsel` for X11, `win32yank` for Windows)
- [Nerd Font](https://www.nerdfonts.com/) recommended

## Installation

This configuration is part of my personal dotfiles. Feel free to explore and adapt any parts that interest you.

For the original kickstart.nvim installation instructions, see: https://github.com/nvim-lua/kickstart.nvim

## Usage

Standard Neovim usage with enhanced functionality through custom plugins and keybindings. Key additions include file navigation tools, productivity enhancements, database interfaces, and AI-assisted coding.

## Upstream

Based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) - a starting point for Neovim configuration that is small, single-file, and completely documented.
