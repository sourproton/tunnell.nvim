local M = {}

local defaults = {
    tmux_target = "{right-of}",
    cell_header = "# %%",
    use_default_keymaps = true,
}

-- Sets buffer-variables `cell_header` and `tmux_target` to values given by user via `vim.fn.input`
function M.config()
    -- cell_header
    vim.b.cell_header = vim.fn.input({
        prompt = "Cell header: ",
        -- autocomplete with current cell header if exists, otherwise autocomplete with global
        default = vim.b.cell_header and vim.b.cell_header or defaults.cell_header,
    })

    -- tmux_target
    vim.b.tmux_target = vim.fn.input({
        prompt = "Tmux target pane: ",
        -- autocomplete with current target if exists, otherwise autocomplete with global
        default = vim.b.tmux_target and vim.b.tmux_target or defaults.tmux_target,
    })
end

-- Sends active selection to target
--
-- Does not accept a range, so <C-U> to remove `'<,'>`
function M.send_selection()
    -- load buffer with lines from active selection
    vim.cmd("silent '<,'>:w !tmux load-buffer - ")

    -- send lines
    local target = vim.b.tmux_target and vim.b.tmux_target or defaults.tmux_target
    vim.fn.system("tmux paste-buffer -dpr -t " .. target)

    -- send <CR> to run cell in REPL
    vim.fn.system("tmux send-keys -t " .. target .. " Enter")
end

-- Sends cell to target
--
-- Cursor does not have to be on the cell header, but anywhere inside the cell
function M.send_cell()
    -- load cell_header
    local cell_header = vim.b.cell_header and vim.b.cell_header or defaults.cell_header

    -- define start of cell
    local start_line = vim.fn.search(cell_header, "bcnW")

    -- if no header is found above cursor, do nothing
    if start_line == 0 then
        print("No cell header found above cursor!")
        return
    end

    -- define cell end
    local end_line = vim.fn.search(cell_header, "nW")

    -- if no header found below cursor, cursor is in the last cell so end line should be the
    -- last line of the file. Otherwise, end line is one line above next cell header
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

-- Setup function for users to call from their plugin managers
function M.setup(user_config)
    -- merge user-config with defaults
    defaults = vim.tbl_deep_extend("force", defaults, user_config or {})

    -- set commands
    vim.api.nvim_create_user_command("TunnelConfig", M.config, {})
    vim.api.nvim_create_user_command("TunnellSelection", M.send_selection, {})
    vim.api.nvim_create_user_command("TunnellCell", M.send_cell, {})

    -- keymaps if desired by user
    if defaults.use_default_keymaps then
        vim.keymap.set({ "n" }, "<leader>t", ":TunnellCell<CR>", { desc = "Tunnell cell" })
        vim.keymap.set({ "v" }, "<leader>t", ":<C-U>TunnellSelection<CR>", { desc = "Tunnell selection" })
    end
end

return M
