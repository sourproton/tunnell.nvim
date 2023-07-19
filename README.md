# tunnell.nvim

A [neovim](https://neovim.io/) plugin to ~send~ tunnell your selections and cells to targets, written in [Lua](https://www.lua.org/).

## Usage

![tunnelldemo](demo/tunnelldemo.gif)

- `:TunnellCell` to tunnell the cell where the cursor is. Note that the cursor doesn't need to be on the cell's header, but anywhere in it
- `:'<,'>TunnellRange` to tunnell the active selection, or any other range of lines with `:startline,endlineTunnellRange`
- `:TunnellConfig` to change the default cell header (`# %%`) or the default target (`{right-of}`) of the current buffer

## Installation

The plugin is simple and easy to install. Just add "sourproton/tunnell.nvim" to your plugin manager and call `setup()`:

```lua
-- using lazy.nvim plugin manager

require("lazy").setup({
    -- ...

    {
        "sourproton/tunnell.nvim",

        config = function()
            require("tunnell.nvim").setup({
                -- optional: change the default values
                -- tmux_target = "{right-of}",
                -- cell_header = "# %%",
            })
        end

        -- optional: lazy load plugin on keymaps
        -- keys = {
        --     { "<leader>tt", ":TunnellCell<CR>",   mode = { "n" }, desc = "Tunnell cell" },
        --     { "<leader>tt", ":TunnellRange<CR>",  mode = { "v" }, desc = "Tunnell range" },
        --     { "<leader>tc", ":TunnellConfig<CR>", mode = { "n" }, desc = "Tunnell config" },
        -- },

        -- optional: lazy load plugin on commands
        -- cmd = {
        --     "TunnellCell",
        --     "TunnellRange",
        --     "TunnellConfig",
        -- },
    }

    -- ...
})
```

## About

I made this plugin to learn Lua and how to make a neovim plugin. I work a lot with REPL-based workflows and tunnelling is something that makes my life a lot easier.

Yes, this plugin does the same as [vim-slime](https://github.com/jpalardy/vim-slime) but has a lot less functionality. You should definitely go with vim-slime.

For now, only tmux targets are supported, but making zellij, kitty, wezterm and other targets should not be hard. I just lack the motivation to do it because I personally use tmux.
