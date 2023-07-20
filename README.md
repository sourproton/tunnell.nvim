# tunnell.nvim

A [neovim](https://neovim.io/) plugin to ~send~ tunnell text from neovim to a tmux target pane, written in [Lua](https://www.lua.org/).

One use case is having the comfort of editing code in neovim, while tunnelling it to a REPL to code iteractively.

## Usage

[tunnelldemo.webm](https://github.com/sourproton/tunnell.nvim/assets/66533348/6a105ffc-9849-41fe-82e3-d1a8750e7375)

- `:TunnellCell` to tunnell the cell where the cursor is. Note that the cursor doesn't need to be on the cell's header, but anywhere in it
- `:'<,'>TunnellRange` to tunnell the active selection, or any other range of lines with `:startline,endlineTunnellRange`
- `:TunnellConfig` to change the default cell header (`# %%`) or the default target (`{right-of}`) of the current buffer

## Installation

With [lazy.nvim](https://github.com/folke/lazy.nvim) plugin manager:

```lua
{
    "sourproton/tunnell.nvim",
    config = true,
}
```

Configuration:

```lua
{
    "sourproton/tunnell.nvim",
    opts = {
        -- defaults are:
        cell_header = "# %%",
        tmux_target = "{right-of}",
    },

    -- to lazy-load on keymaps:
    keys = {
        -- suggestions for keymaps:
        { "<leader>tt", ":TunnellCell<CR>",   mode = { "n" }, desc = "Tunnell cell" },
        { "<leader>tt", ":TunnellRange<CR>",  mode = { "v" }, desc = "Tunnell range" },
        { "<leader>tc", ":TunnellConfig<CR>", mode = { "n" }, desc = "Tunnell config" },
    },

    -- to lazy-load on commands:
    cmd = {
        "TunnellCell",
        "TunnellRange",
        "TunnellConfig",
    },
}
```


## About

I made this plugin to learn [Lua](https://www.lua.org/) and how to make a neovim plugin. I work a lot with REPL-based workflows and tunnelling is something that makes my life a lot easier.

Yes, this plugin does the same as [vim-slime](https://github.com/jpalardy/vim-slime) but has a lot less functionality. You should definitely go with vim-slime.

Name inspired by [quantum tunnelling](https://en.wikipedia.org/wiki/Quantum_tunnelling).

For now, only tmux targets are supported, but making zellij, kitty, wezterm and other targets should not be hard. I just lack the motivation to do it because I personally use tmux.
