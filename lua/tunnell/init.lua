local cell_header = "# %%"

-- sets buffer-variable `cell_header` to value read from `vim.fn.input`
local function set_cell_header()
    vim.b.cell_header = vim.fn.input("Cell header: ")
end

-- sets buffer-variable `tmuxtarget` to value read from `vim.fn.input`
local function set_tmux_target()
    vim.b.tmux_target = vim.fn.input("Tmux target pane: ")
end

-- sends selected text to target
local function send_selection()
    -- check if `tmuxtarget` exists, call `config_tmuxtarget` if not
    if vim.b.tmux_target == nil then set_tmux_target() end

    -- load tmux buffer with selected text
    vim.api.nvim_feedkeys(":'<,'>:w !tmux load-buffer - \r", "t", true)
    -- paste buffer to target
    vim.api.nvim_feedkeys(":silent !tmux paste-buffer -dpr -t " .. vim.b.tmux_target .. "\r", "t", true)
    -- send carriage return
    vim.api.nvim_feedkeys(":silent !tmux send-keys -t " .. vim.b.tmux_target .. " Enter\r", "t", true)
end

-- sends cell to target
local function send_cell()
    -- check if `tmuxtarget` exists, call `config_tmuxtarget` if not
    if vim.b.tmux_target == nil then set_tmux_target() end

    -- go to start of the cell
    vim.api.nvim_feedkeys("/" .. (vim.b.cell_header ~= nil and vim.b.cell_header or cell_header) .. "\rN", "t", true)

    -- check if it's the last cell
    local sc = vim.fn.searchcount()
    local last_cell = sc.current == sc.total

    if last_cell then
        -- if it's the last cell, select until end of file
        vim.api.nvim_feedkeys("vG", "t", true)
    else
        -- if not in the last cell, select until one line above next cell
        vim.api.nvim_feedkeys("vnk", "t", true)
    end

    -- send selection
    send_selection()

    -- go to next cell
    vim.api.nvim_feedkeys("n", "t", true)
end
print("Hello World")

return {
    set_cell_header = set_cell_header,
    set_tmux_target = set_tmux_target,
    send_selection = send_selection,
    send_cell = send_cell,
}
