local M = {}

local defaults = {
    tmux_target = "{right-of}",
    cell_header = "# %%",
}

vim.g.default_tmux_target = defaults.tmux_target
vim.g.default_cell_header = defaults.cell_header

-- sets buffer-variable `cell_header` to value read from `vim.fn.input`
M.set_cell_header = function()
    vim.b.tunnell_cell_header = vim.fn.input({
        prompt = "Cell header: ",
        -- autocompletes with current cell header if one has been set, otherwise autocompletes with global
        -- cell header
        default = vim.b.tunnell_cell_header and vim.b.tunnell_cell_header or vim.g.default_cell_header,
    })
end

-- sets buffer-variable `tmuxtarget` to value read from `vim.fn.input`
M.set_tmux_target = function()
    vim.b.tunnell_tmux_target = vim.fn.input({
        prompt = "Tmux target pane: ",
        -- autocompletes with current target if one has been set, otherwise autocompletes with global target
        default = vim.b.tunnell_tmux_target and vim.b.tunnell_tmux_target or vim.g.default_tmux_target,
    })
end

-- sends selected text to target
M.send_selection = function()
    local target = vim.b.tunnell_tmux_target and vim.b.tunnell_tmux_target or vim.g.default_tmux_target
    -- load tmux buffer with selected text
    vim.api.nvim_feedkeys(":'<,'>:w !tmux load-buffer - \r", "t", true)
    -- paste buffer to target
    vim.api.nvim_feedkeys(":silent !tmux paste-buffer -dpr -t " .. target .. "\r", "t", true)
    -- send carriage return
    vim.api.nvim_feedkeys(":silent !tmux send-keys -t " .. target .. " Enter\r", "t", true)
end

-- sends cell to target
M.send_cell = function()
    local cell_header = vim.b.tunnell_cell_header and vim.b.tunnell_cell_header or vim.g.default_cell_header
    -- go to start of the cell
    -- "/" to enter search mode
    -- "{cell_header}\r" to go to the next cell header
    -- "N" to go to the beggining of the original cell
    vim.api.nvim_feedkeys("/" .. cell_header .. "\rN", "t", true)

    -- know in which cell the cursor is
    local sc = vim.fn.searchcount()

    -- check if it's the last cell
    if sc.current == sc.total then
        -- if it's the last cell, select until end of file
        -- "v" to enter select mode
        -- "G" to extend the selection until the end of the file (end of last cell)
        vim.api.nvim_feedkeys("vG", "t", true)
    else
        -- if not in the last cell, select until one line above next cell
        -- "v" to enter select mode
        -- "n" to extend the selection until the header of the next cell
        -- "k" to go back one line
        vim.api.nvim_feedkeys("vnk", "t", true)
    end

    -- send selection
    M.send_selection()

    -- go to next cell
    -- the cell header is still in the search history, so "n" jumps to the next cell header
    vim.api.nvim_feedkeys("n", "t", true)
end

vim.api.nvim_create_user_command("TunnelSetCellHeader", M.set_cell_header, {})
vim.api.nvim_create_user_command("TunnelSetTmuxTarget", M.set_tmux_target, {})
vim.api.nvim_create_user_command("TunnelSendSelection", M.send_selection, {})
vim.api.nvim_create_user_command("TunnelSendCell", M.send_cell, {})

return M
