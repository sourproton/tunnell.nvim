# tunnell.nvim

A [neovim](https://neovim.io/) plugin to tunnell your selections and cells to targets, written in [Lua](https://www.lua.org/).

## Tunnelling

No worries, we are not going to get into [quantum physics](https://en.wikipedia.org/wiki/Quantum_tunnelling), because tunnell.nvim is about ~sending~ tunnelling a selection of your buffer to a target. The plugin can also automatically detect the code cell your cursor is in and tunnell it.

## Usage

## Configuration

## About

Yes, this plugin does what [vim-slime](https://github.com/jpalardy/vim-slime) does but it's written in Lua and has a lot less functionality. You should definitely go with vim-slime.

I made this plugin to learn Lua and how to make a neovim plugin. I work a lot with REPL-based workflows and tunnelling is something that makes my life a lot easier.

For now, only tmux targets are supported, but making zellij, kitty, wezterm and other targets should not be hard. I just lack the motivation to do it because I personally use tmux.
