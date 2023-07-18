# tunnell.nvim

A [neovim](https://neovim.io/) plugin to tunnell your selections and cells to targets, written in [Lua](https://www.lua.org/).

## Usage

![tunnelldemo](demo/tunneldemo.gif)

## Installation

The plugin is simple and easy to install. Just add "sourproton/tunnell.nvim" to your package manager and call `setup()`:

```lua
-- using lazy.nvim package manager

require("lazy").setup({
    -- ...

    {
        "sourproton/tunnell.nvim",
        config = function()
            require("tunnell.nvim").setup({
                -- the default options are:
                tmux_target = "{right-of}",
                cell_header = "# %%",
                use_default_keymaps = true,
            })
        end
    }

    -- ...
})
```

The plugin exports 3 commands:

- `:TunnellConfig`, to change the values of `cell_header` and `tmux_target` for the current buffer
- `:TunnellSelection`, to tunnell the active selection when in visual mode (remove the `'<,'>` added by neovim in the command line)
- `:TunnellCell`, to tunnell the cell where the cursor is when in normal mode

If `use_default_keymaps` is `true`, then `<leader>t` is mapped to `:<C-U>TunnellSelection<CR>` in visual mode and to `:TunnelCell<CR>` when in normal mode

## About

Yes, this plugin does what [vim-slime](https://github.com/jpalardy/vim-slime) does but it's written in Lua and has a lot less functionality. You should definitely go with vim-slime.

I made this plugin to learn Lua and how to make a neovim plugin. I work a lot with REPL-based workflows and tunnelling is something that makes my life a lot easier.

For now, only tmux targets are supported, but making zellij, kitty, wezterm and other targets should not be hard. I just lack the motivation to do it because I personally use tmux.
