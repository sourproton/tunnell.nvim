local M = {}

local defaults = {
    tmux_target = "{right-of}",
    cell_header = "# %%",
}

-- Sets buffer-variables `cell_header` and `tmux_target` to values given by user via `vim.fn.input`
local function config()
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

-- Tunnells range `r` to target
--
-- Reads `r.line1` and `r.line2`
local function tunnell_range(r)
    -- load buffer with range from `r.line1` to `r.line2`
    vim.cmd("silent " .. r.line1 .. "," .. r.line2 .. ":w !tmux load-buffer - ")

    -- tunnell lines
    local target = vim.b.tmux_target and vim.b.tmux_target or defaults.tmux_target
    vim.fn.system("tmux paste-buffer -dpr -t " .. target)

    -- tunnell <CR> to run cell in REPL
    vim.fn.system("tmux send-keys -t " .. target .. " Enter")
end

-- Tunnells cell to target
--
-- Cursor does not have to be on the cell header, but anywhere inside the cell
local function tunnell_cell()
    -- load cell_header
    local cell_header = vim.b.cell_header and vim.b.cell_header or defaults.cell_header

    -- define start of cell
    -- 'b'  search Backward instead of forward
    -- 'c'  accept a match at the Cursor position
    -- 'n'  do Not move the cursor
    -- 'W'  don't Wrap around the end of the file
    local start_line = vim.fn.search(cell_header, "bcnW")

    -- if no header is found above cursor, do nothing
    if start_line == 0 then
        print("No cell header found above cursor!")
        return
    end

    -- define end of cell
    local end_line = vim.fn.search(cell_header, "nW")

    -- if no header found below cursor, cursor is in the last cell so end line should be the
    -- last line of the file. Otherwise, end line is one line above next cell header
    if end_line == 0 then
        end_line = vim.fn.line("$")
    else
        end_line = end_line - 1
    end

    -- tunnell cell range
    tunnell_range({ line1 = start_line, line2 = end_line })

    -- put cursor on next cell
    vim.cmd("silent /" .. cell_header)
end

-- create user commands
vim.api.nvim_create_user_command("TunnellConfig", config, {})
vim.api.nvim_create_user_command("TunnellRange", tunnell_range, { range = true })
vim.api.nvim_create_user_command("TunnellCell", tunnell_cell, {})

-- Setup function for users to call from their plugin managers
function M.setup(user_config)
    -- merge user-config with defaults
    defaults = vim.tbl_deep_extend("force", defaults, user_config or {})
end

return M
