local M = {}

local wk = require("which-key")
local map = require("common.utils").map

function M.setup()
    -- TODO: Get '?' to map to popup for current operator
    -- FIX: gc operator

    local presets = require("which-key.plugins.presets")
    -- presets.operators['"_d'] = "Delete blackhole"
    presets.operators["gc"] = "Commenter"
    presets.operators["s"] = "Substitute"

    wk.register(
        {
            ["d"] = {[["_d]], "Delete blackhole"}
        },
        {prefix = "", preset = true}
    )

    wk.setup {
        plugins = {
            marks = true, -- shows a list of your marks on ' and `
            registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
            spelling = {
                enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
                suggestions = 20 -- how many suggestions should be shown in the list?
            },
            presets = {
                -- adds help for a bunch of default keybindings
                operators = true, -- adds help for operators like d, y, ... and registers them for motion
                motions = true, -- adds help for motions
                text_objects = true, -- help for text objects triggered after entering an operator
                windows = false, -- default bindings on <c-w>
                nav = true, -- misc bindings to work with windows
                z = true, -- bindings for folds, spelling and others prefixed with z
                g = true -- bindings for prefixed with g
            }
        },
        operators = {
            -- add operators that will trigger motion and text object completion
            gc = "Comments",
            -- s = "Substitute",
            ['"_d'] = "Delete (blackhole)",
            ['d'] = "Delete (blackhole 2)"
        },
        key_labels = {
            -- override the label used to display some keys. It doesn't effect WK in any other way.
            -- For example:
            ["<space>"] = "SPC",
            ["<cr>"] = "RET",
            ["<tab>"] = "TAB"
        },
        icons = {
            breadcrumb = "»", -- symbol used in the command line area that shows active key combo
            separator = "➜", -- symbol used between a key and it's label
            group = "+" -- symbol prepended to a group
        },
        popup_mappings = {
            scroll_down = "<c-d>", -- binding to scroll down inside the popup
            scroll_up = "<c-u>" -- binding to scroll up inside the popup
        },
        window = {
            border = "rounded", -- none, single, double, shadow
            position = "bottom", -- bottom, top
            margin = {1, 0, 1, 0}, -- extra window margin [top, right, bottom, left]
            padding = {2, 2, 2, 2}, -- extra window padding [top, right, bottom, left]
            winblend = 0
        },
        layout = {
            height = {min = 4, max = 25}, -- min and max height of the columns
            width = {min = 20, max = 50}, -- min and max width of the columns
            spacing = 3, -- spacing between columns
            align = "left" -- align columns left, center or right
        },
        -- hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "},
        hidden = {"lua", "^ ", "<silent>"}, -- hide mapping boilerplate
        show_help = true, -- show help message on the command line when the popup is visible
        triggers_nowait = {}, -- list of triggers, where WhichKey should not wait for timeoutlen and show immediately
        triggers = "auto"
        -- triggers = {"z=", "auto"} -- automatically setup triggers
        -- triggers = {"<leader>"} -- or specify a list manually
    }
end

local function init()
    -- cmd([[highlight default link WhichKey          htmlH1]])
    -- cmd([[highlight default link WhichKeySeperator String]])
    -- cmd([[highlight default link WhichKeyGroup     Keyword]])
    -- cmd([[highlight default link WhichKeyDesc      Include]])
    -- cmd([[highlight default link WhichKeyFloat     CursorLine]])
    -- cmd([[highlight default link WhichKeyValue     Comment]])

    M.setup()

    map("v", "<Leader>wh", "<Esc><Cmd>WhichKey '' v<CR>")

    wk.register(
        {
            ["<Leader>wh"] = {"<Cmd>WhichKey '' n<CR>", "WhichKey normal mode"},
            ["<Leader><Leader><CR>"] = {[[<Cmd>WhichKey \ \ <CR>]], "WhichKey Leader Leader"},
            ["<Leader><CR>"] = {[[<Cmd>WhichKey \ <CR>]], "WhichKey Leader"},
            ["<LocalLeader><CR>"] = {"<Cmd>WhichKey <LocalLeader><CR>", "WhichKey LocalLeader"},
            [";<CR>"] = {"<Cmd>WhichKey ;<CR>", "WhichKey colon"},
            ["g<CR>"] = {"<Cmd>WhichKey g<CR>", "WhichKey g"},
            ["[<CR>"] = {"<Cmd>WhichKey [<CR>", "WhichKey ["},
            ["]<CR>"] = {"<Cmd>WhichKey ]<CR>", "WhichKey ]"},
            ["<C-x><CR>"] = {"<Cmd>WhichKey ]<CR>", "WhichKey <C-x>"},
            ["c<CR>"] = {[[<Cmd>WhichKey c<CR>]], "WhichKey c"},
            ["<C-w><CR>"] = {[[<Cmd>WhichKey <C-w><CR>]], "WhichKey <C-w>"}
        }
    )

    wk.register(
        {
            ["?"] = {"<Cmd>WhichKey d<CR>", "WhichKey operator"}
        },
        {mode = "o"}
    )

    -- registers.nvim is better for this
    -- map(
    --     '"',
    --     "n",
    --     function()
    --         require("which-key").show("@", {mode = "n", auto = true})
    --     end
    -- )

    -- K.n("<SubLeader><CR>", "<Cmd>WhichKey <SubLeader><CR>")
    -- K.n("<EasyMotion><CR>", "<Cmd>WhichKey <EasyMotion><CR>")
end

init()

return M
