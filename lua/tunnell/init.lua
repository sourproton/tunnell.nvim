local M = {}

local defaults = {
    tmux_target = "{right-of}",
    cell_header = "# %%",
    use_default_keymaps = true,
}

-- sets buffer-variables `cell_header` and `tmux_target`
function M.config()
    -- cell header
    vim.b.cell_header = vim.fn.input({
        prompt = "Cell header: ",
        -- autocompletes with current cell header if one has been set, otherwise autocompletes with global
        -- cell header
        default = vim.b.cell_header and vim.b.cell_header or defaults.cell_header,
    })

    -- tmux target
    vim.b.tmux_target = vim.fn.input({
        prompt = "Tmux target pane: ",
        -- autocompletes with current target if one has been set, otherwise autocompletes with global target
        default = vim.b.tmux_target and vim.b.tmux_target or defaults.tmux_target,
    })
end

-- sends selected text to target
function M.send_selection()
    -- load buffer with lines
    vim.cmd(":silent '<,'>:w !tmux load-buffer - ")

    -- send lines
    local target = vim.b.tmux_target and vim.b.tmux_target or defaults.tmux_target
    vim.cmd("silent !tmux paste-buffer -dpr -t " .. target)

    -- send <CR>
    vim.cmd("silent !tmux send-keys -t " .. target .. " Enter")
end

-- sends cell to target
function M.send_cell()
    local cell_header = vim.b.cell_header and vim.b.cell_header or defaults.cell_header

    -- define start and end of cell
    local start_line = vim.fn.search(cell_header, "bcnW")

    if start_line == 0 then
        print("no cell header found")
        return
    end

    local end_line = vim.fn.search(cell_header, "nW")
    end_line = end_line == 0 and vim.fn.line("w$") or end_line - 1

    -- load buffer with lines
    vim.cmd("silent " .. start_line .. "," .. end_line .. ":w !tmux load-buffer - ")

    -- send lines
    local target = vim.b.tmux_target and vim.b.tmux_target or defaults.tmux_target
    vim.cmd("silent !tmux paste-buffer -dpr -t " .. target)

    -- send <CR>
    vim.cmd("silent !tmux send-keys -t " .. target .. " BSpace Enter")

    -- put curson on next cell
    vim.cmd("silent /" .. cell_header)
end

-- user-configurable function
function M.setup(user_config)
    -- merge user-config with defaults
    defaults = vim.tbl_deep_extend("force", defaults, user_config or {})

    -- set commands
    vim.api.nvim_create_user_command("TunnelConfig", M.config, {})
    vim.api.nvim_create_user_command("TunnellSelection", M.send_selection, {})
    vim.api.nvim_create_user_command("TunnellCell", M.send_cell, {})

    -- keymaps
    if defaults.use_default_keymaps then
        vim.keymap.set({ "n" }, "<leader>t", ":TunnellCell<CR>", { desc = "Tunnell cell" })
        vim.keymap.set({ "v" }, "<leader>t", ":<C-U>TunnellSelection<CR>", { desc = "Tunnell selection" })
    end
end

return M
