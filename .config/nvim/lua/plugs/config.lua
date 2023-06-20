---@module 'plugs.config'
local M = {}

local F = Rc.F
local C = Rc.shared.C
local utils = Rc.shared.utils
local hl = Rc.shared.hl
local xprequire = utils.mod.xprequire

local lazy = require("usr.lazy")
local log = Rc.lib.log

local wk = require("which-key")

local Abbr = Rc.api.abbr
local map = Rc.api.map
local command = Rc.api.command
local augroup = Rc.api.augroup
-- local autocmd = Rc.api.autocmd

local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local api = vim.api

-- ╭──────────────────────────────────────────────────────────╮
-- │                          eregex                          │
-- ╰──────────────────────────────────────────────────────────╯
function M.eregex()
    g.eregex_forward_delim = "/"
    g.eregex_backward_delim = "?"

    map("n", "<Leader>es", "<Cmd>call eregex#toggle()<CR>", {desc = "Toggle eregex"})
    map("n", ",/", "<Cmd>call eregex#toggle()<CR>", {desc = "Toggle eregex"})
    map("n", "<Leader>S", ":%S//g<Left><Left>", {desc = "Global replace (E2v)"})
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                           Suda                           │
-- ╰──────────────────────────────────────────────────────────╯
function M.suda()
    -- map("c", "w!!", ":SudaWrite<CR>")
    map("n", "<Leader>W", ":SudaWrite<CR>")
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                         LineDiff                         │
-- ╰──────────────────────────────────────────────────────────╯
function M.linediff()
    map("n", "<Leader>ld", "Linediff", {cmd = true})
    map("x", "<Leader>ld", ":Linediff<CR>")
    map("n", "<Leader>lD", "LinediffReset", {cmd = true})

    map(
        "x",
        "D",
        [[mode() ==# "V" ? ':Linediff<CR>' : 'D']],
        {expr = true, desc = "Delete or diff line"}
    )

    Abbr:new("c", "ldr", "LinediffReset")
end

--  ╭──────────────────────────────────────────────────────────╮
--  │                         DirDiff                          │
--  ╰──────────────────────────────────────────────────────────╯
function M.dirdiff()
    g.DirDiffGetKeyMap = "<LocalLeader>dg"
    g.DirDiffPutKeyMap = "<LocalLeader>dp"
    g.DirDiffNextKeyMap = "<LocalLeader>dj"
    g.DirDiffPrevKeyMap = "<LocalLeader>dk"

    g.DirDiffEnableMappings = 1
    g.DirDiffIgnoreFileNameCase = 0
    -- g.DirDiffExcludes = "CVS,*.class,*.exe,.*.swp"
    -- g.DirDiffIgnore = "Id:,Revision:,Date:"
    g.DirDiffSort = 1
    g.DirDiffWindowSize = 14
    g.DirDiffIgnoreCase = 0
    -- g.DirDiffForceLang = "C"
    -- g.DirDiffForceShell = "C"
    -- g.DirDiffDynamicDiffText = 0
    -- g.DirDiffTextFiles = "Files "
    -- g.DirDiffTextAnd = " and "
    -- g.DirDiffTextDiffer = " differ"
    -- g.DirDiffTextOnlyIn = "Only in "
    -- g.DirDiffTheme = "github"
    g.DirDiffSimpleMap = 1
    -- g.DirDiffAddArgs = "-w"
end

--  ╭──────────────────────────────────────────────────────────╮
--  │                     HighlightedUndo                      │
--  ╰──────────────────────────────────────────────────────────╯
function M.hlundo()
    g["highlightedundo#highlight_mode"] = 1
    g["highlightedundo#highlight_duration_delete"] = 250
    g["highlightedundo#highlight_duration_add"] = 500

    hl.plugin(
        "HLUndo",
        {
            HighlightedundoAdd = {link = "DiffviewStatusAdded"},
            HighlightedundoDelete = {link = "DiffviewStatusDeleted"},
            HighlightedundoChange = {link = "DiffviewFilePanelCounter"},
            -- HighlightedundoChange = {link = "DiffviewStatusModified"},
        }
    )
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                         VCooler                          │
-- ╰──────────────────────────────────────────────────────────╯
function M.vcoolor()
    map("n", "<Leader>pc", ":VCoolor<CR>", {desc = "Insert hex color"})
    map("n", "<Leader>yb", ":VCoolIns h<CR>", {desc = "Insert HSL color"})
    map("n", "<Leader>yr", ":VCoolIns r<CR>", {desc = "Insert RGB color"})

    g.vcoolor_custom_picker = utils.list({
        "yad",
        '--title="Color Picker"',
        "--color",
        "--splash",
        "--on-top",
        "--skip-taskbar",
        "--init-color=",
    }, " ")
    -- g.vcoolor_custom_picker = utils.list({
    --     "epick",
    -- }, " ")
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                        UltiSnips                         │
-- ╰──────────────────────────────────────────────────────────╯
function M.ultisnips()
    -- This works on snippets like #! where a popup menu doesn't appear
    g.UltiSnipsExpandTrigger = "<NUL>"
    g.UltiSnipsListSnippets = "<NUL>"

    -- g.UltiSnipsJumpForwardTrigger = "<C-j>"
    -- g.UltiSnipsJumpBackwardTrigger = "<C-k>"
    -- g.UltiSnipsListSnippets = "<C-u>"
    g.UltiSnipsEditSplit = "horizontal"
end

--  ╭──────────────────────────────────────────────────────────╮
--  │                          FSRead                          │
--  ╰──────────────────────────────────────────────────────────╯
function M.fsread()
    g.flow_strength = 0.7         -- low: 0.3, middle: 0.5, high: 0.7 (default)
    g.skip_flow_default_hl = true -- If you want to override default highlights

    hl.plugin("FSRead", {
        FSPrefix = {fg = "#cdd6f4"},
        FSSuffix = {fg = "#6C7086"},
    })
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                         Listish                          │
-- ╰──────────────────────────────────────────────────────────╯
function M.listish()
    local listish = F.npcall(require, "listish")
    if not listish then
        return
    end

    listish.config({
        theme_list = false,
        clearqflist = "ClearQuickfix",  -- command
        clearloclist = "ClearLoclist",  -- command
        clear_notes = "ClearListNotes", -- command
        lists_close = "<Nop>",          -- closes both qf/local lists
        in_list_dd = "dd",              -- delete current item in the list
        quickfix = {
            open = "qo",
            on_cursor = "qa", -- add current position to the list
            add_note = "qA",  -- add current position with your note to the list
            clear = "qe",     -- clear all items
            close = "<Nop>",
            next = "<Nop>",
            prev = "<Nop>",
        },
        locallist = {
            open = "<Leader>wo",
            on_cursor = "<Leader>wa",
            add_note = "<Leader>wn",
            clear = "<Leader>wi",
            close = "<Nop>",
            next = "<Nop>",
            prev = "<Nop>",
        },
    })

    wk.register({
        q = {
            name = "+quickfix",
            o = "Quickfix open",
            a = "Quickfix add current line",
            A = "Quickfix add note",
            e = "Quickfix clear items (empty)",
        },
        ["<Leader>wo"] = "Loclist open",
        ["<Leader>wa"] = "Loclist add current line",
        ["<Leader>wn"] = "Loclist add note",
        ["<Leader>wi"] = "Loclist clear items",
    })
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                           Sort                           │
-- ╰──────────────────────────────────────────────────────────╯
function M.sort()
    local sort = F.npcall(require, "sort")
    if not sort then
        return
    end

    sort.setup({delimiters = {",", "|", ";", ":", "s", "t"}})

    map("n", "gz", "Sort", {cmd = true, desc = "Sort: command"})
    map("x", "gz", ":Sort<CR>", {desc = "Sort selection"})
    map("n", "gS", "<Plug>Opsort", {desc = "Sort: operator"})

    -- [delimiter] = Manually set delimiter ([s]: space, [t]: tab, [!, ?, &, ... (Lua %p)])
    -- [!]         = Sort order is reversed
    -- [n]         = First decimal number
    -- [b]         = First binary number
    -- [o]         = First octal number
    -- [x]         = First hexadecimal number
    -- [i]         = Case is ignored
    -- [u]         = Keep the first instance of words within selection
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                          LuaPad                          │
-- ╰──────────────────────────────────────────────────────────╯
function M.luapad()
    local luapad = F.npcall(require, "luapad")
    if not luapad then
        return
    end

    luapad.setup({
        count_limit = 150000,
        preview = true,
        error_indicator = true,
        print_highlight = "Comment",
        error_highlight = "ErrorMsg",
        eval_on_move = false,
        eval_on_change = true,
        split_orientation = "vertical",
        on_init = function()
            xprequire("noice").disable()
        end,
        -- Global variables provided on startup
        context = {
            S = require("usr.shared"),
            U = require("usr.shared.utils"),
            arr = {"abc", "def", "ghi", "jkl"},
            narr = {1, 2, 3, 4, 5},
            tt = _t({abc = 123, def = 456, ghi = 789, jkl = 1011}),
            t = {abc = 123, def = 456, ghi = 789, jkl = 1011},
            mix = {["34"] = 123, def = "str", [5] = 789, ["-0-"] = 1011},
            shout = function(str)
                return ((str):upper() .. "!")
            end,
        },
    })

    nvim.autocmd.lmb__Luapad = {
        event = "BufLeave",
        pattern = "*Luapad.lua",
        command = function()
            xprequire("noice").enable()
        end,
        desc = "Enable noice when leaving Luapad",
    }
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                         HlsLens                          │
-- ╰──────────────────────────────────────────────────────────╯
function M.hlslens()
    local hlslens = F.npcall(require, "hlslens")
    if not hlslens then
        return
    end

    hlslens.setup({
        auto_enable = true,
        enable_incsearch = true,
        -- Clear all lens & hl when cursor is out of the range of the matched instance
        -- I had this on my own, but removed it due to this being added here
        calm_down = true,
        nearest_only = false,
        nearest_float_when = "auto",
        float_shadow_blend = 50,
        virt_priority = 100,
        ---@param plist {start_pos: integer, end_pos: integer}
        ---@param bufnr bufnr
        ---@param changedtick integer
        ---@param patt string
        build_position_cb = function(plist, bufnr, changedtick, patt)
            require("scrollbar.handlers.search").handler.show(plist.start_pos)
        end,
    })

    command("HlSearchLensToggle", hlslens.toggle, {desc = "Togggle HLSLens"})

    ---@diagnostic disable-next-line:unused-function
    local function nN(char)
        local ok, winid = hlslens.nNPeekWithUFO(char)
        if ok and winid then
            local bufnr = api.nvim_win_get_buf(winid)
            local keys = {"a", "i", "o", "A", "I", "O", "gd", "gr",
                "gD", "gy", "gi", "gR", "gs", "go", "gt",}
            for _, k in ipairs(keys) do
                map("n", k, "<Tab><CR>" .. k, {noremap = false, buffer = bufnr})
            end

            map("n", "<CR>", function()
                utils.normal({"i", "m"}, "<Tab><CR>")
            end, {buffer = true})
        end
        --     fn.execute(("norm! %d%szv"):format(vim.v.count1, char))
        --     -- utils.normal("n", ("%d%szv"):format(vim.v.count1, char))
        --     hlslens.start()
        require("specs").show_specs()
    end

    -- map("n", "n", F.ithunk(nN, "n"))
    -- map("n", "N", F.ithunk(nN, "N"))

    map(
        "n",
        "n",
        ("%s%s%s"):format(
            [[<Cmd>execute('norm! ' . v:count1 . 'nzv')<CR>]],
            [[<Cmd>lua require('hlslens').start()<CR>]],
            [[<Cmd>lua require("specs").show_specs()<CR>]]
        )
    )
    map(
        "n",
        "N",
        ("%s%s%s"):format(
            [[<Cmd>execute('norm! ' . v:count1 . 'Nzv')<CR>]],
            [[<Cmd>lua require('hlslens').start()<CR>]],
            [[<Cmd>lua require("specs").show_specs()<CR>]]
        )
    )

    g["asterisk#keeppos"] = 1

    map(
        "n",
        "*",
        [[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]],
        {desc = "Search forward <word>"}
    )
    map(
        "n",
        "#",
        [[<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>]],
        {desc = "Search backward <word>"}
    )
    map(
        "n",
        "g*",
        [[<Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>]],
        {desc = "Search forward word"}
    )
    map(
        "n",
        "g#",
        [[<Plug>(asterisk-gz#)<Cmd>lua require('hlslens').start()<CR>]],
        {desc = "Search backward word"}
    )

    map("x", "*", [[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]])
    map("x", "#", [[<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>]])
    map("x", "g*", [[<Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>]])
    map("x", "g#", [[<Plug>(asterisk-gz#)<Cmd>lua require('hlslens').start()<CR>]])

    map(
        {"n", "x"},
        "gL",
        function()
            vim.schedule(
                function()
                    if hlslens.exportLastSearchToQuickfix() then
                        cmd("cw")
                    end
                end
            )
            return ":noh<CR>"
        end,
        {silent = true, expr = true, desc = "Export last search to QF"}
    )
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                          Specs                           │
-- ╰──────────────────────────────────────────────────────────╯
function M.specs()
    local specs = F.npcall(require, "specs")
    if not specs then
        return
    end

    specs.setup(
        {
            show_jumps = true,
            ---@diagnostic disable-next-line: param-type-mismatch
            min_jump = fn.winheight("%"),
            popup = {
                delay_ms = 0, -- delay before popup displays
                inc_ms = 20,  -- time increments used for fade/resize effects
                blend = 20,   -- starting blend, between 0-100 (fully transparent), see :h winblend
                width = 20,
                winhl = "PMenu",
                fader = specs.linear_fader,
                resizer = specs.shrink_resizer,
            },
            ignore_filetypes = {C.vec2tbl(Rc.blacklist.ft)},
            ignore_buftypes = {nofile = true},
        }
    )
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                          Caser                           │
-- ╰──────────────────────────────────────────────────────────╯
function M.caser()
    g.caser_prefix = "cr"

    wk.register(
        {
            ["crm"] = "Caser: PascalCase (MixedCase)",
            ["crp"] = "Caser: PascalCase (MixedCase)",
            ["crc"] = "Caser: camelCase",
            ["crt"] = "Caser: Title case",
            ["cr<Space>"] = "Caser: space case",
            ["cr-"] = "Caser: kebab-case (dash-case)",
            ["crk"] = "Caser: kebab-case (dash-case)",
            ["crK"] = "Caser: Title-Kebab-Case",
            ["cr."] = "Caser: dot.case",
            ["cr_"] = "Caser: snake_case",
            ["crU"] = "Caser: UPPER_SNAKE_CASE",
            ["cru"] = {"gU", "Caser: UPPER CASE"},
            ["crl"] = {"gu", "Caser: lower case"},
            ["crs"] = {"<Plug>CaserSnakeCase", "Caser: snake_case"},
            ["crd"] = {"<Plug>CaserDotCase", "Caser: dot.case"},
            ["crS"] = {"<Plug>CaserSentenceCase", "Caser: Sentence case"},
        },
        {mode = {"n", "x"}}
    )
end

-- function M.matchup_is_comment_opfunc()
--     return
--     -- <Lua 834: ~/.local/share/nvim/site/pack/packer/opt/Comment.nvim/lua/Comment/api.lua:246>
--         vim.o.operatorfunc ==
--         fn.matchstr(fn.maparg("<Plug>(comment_toggle_linewise)", "n"),
--             [[<Lua \d\{1,4\}: .*/Comment\.nvim\/lua\/Comment\/api\.lua: \d\{1,3\}>]])
-- end

-- ╭──────────────────────────────────────────────────────────╮
-- │                         MatchUp                          │
-- ╰──────────────────────────────────────────────────────────╯
function M.matchup()
    -- g.loaded_matchit = 1

    g.matchup_enabled = 1
    g.matchup_mouse_enabled = 1      -- double click
    g.matchup_mappings_enabled = 0   -- all matches
    g.matchup_matchparen_enabled = 1 -- match highlighting
    g.matchup_motion_enabled = 1     -- -% % [% ]%
    g.matchup_text_obj_enabled = 1   -- a% i%
    g.matchup_surround_enabled = 1
    g.matchup_transmute_enabled = 0

    -- === Motion
    g.matchup_motion_override_Npercent = 0
    g.matchup_motion_cursor_end = 0
    g.matchup_text_obj_linewise_operators = {"d", "y"}

    -- === MatchParen
    g.matchup_matchparen_stopline = 1500     -- num lines to search
    g.matchup_matchparen_timeout = 100       -- can be b:
    g.matchup_matchparen_insert_timeout = 60 -- can be b:
    g.matchup_matchparen_deferred = 1
    -- g.matchup_matchparen_deferred_fade_time = 450 -- hide if on match for N
    g.matchup_matchparen_deferred_show_delay = 50
    g.matchup_matchparen_deferred_hide_delay = 300
    g.matchup_matchparen_pumvisible = 1
    g.matchup_matchparen_nomode = ""
    g.matchup_matchparen_hi_surround_always = 1
    -- g.matchup_matchparen_hi_background = 1

    -- g.matchup_delim_stopline = 500
    g.matchup_delim_start_plaintext = 1 -- loaded for all buffers
    g.matchup_delim_noskips = 2         -- in comments -- 0: All, 1: Brackets
    -- FIX: This isn't working
    g.matchup_delim_nomids = 0          -- match func return end

    g.matchup_matchparen_offscreen = {}
    -- g.matchup_matchparen_offscreen = {method = "popup", highlight = "MatchParenCur", border = true}
    -- g.matchup_matchparen_offscreen = {method = "status_manual"}

    hl.plugin(
        "Matchup",
        {
            theme = {
                kimbox = {
                    MatchWord = {link = "Underlined"},
                    MatchParen = {bg = "#5e452b", underline = true},
                },
                kanagawa = {
                    MatchWord = {link = "Underlined"},
                    MatchParen = {underline = true},
                },
            },
        }
    )

    map({"n", "x", "o"}, "%", "<Plug>(matchup-%)", {desc = "Matchup:next matching"})
    map({"n", "x", "o"}, "g%", "<Plug>(matchup-g%)", {desc = "Matchup: prev matching"})
    map("o", "g5", "<Plug>(matchup-g%)", {desc = "Matchup: prev matching"})

    map({"n", "x", "o"}, "[%", "<Plug>(matchup-[%)", {desc = "Matchup: prev outer open"})
    map({"n", "x", "o"}, "]%", "<Plug>(matchup-]%)", {desc = "Matchup: next outer close"})
    map({"n", "x", "o"}, "[4", "<Plug>(matchup-[%)", {desc = "Matchup: prev outer open"})
    map({"n", "x", "o"}, "]4", "<Plug>(matchup-]%)", {desc = "Matchup: next outer close"})

    map({"n", "x", "o"}, "[5", "<Plug>(matchup-Z%)")
    map({"n", "x", "o"}, "]5", "<Plug>(matchup-z%)")
    map({"n", "x", "o"}, "z{", "<Plug>(matchup-Z%)", {desc = "Matchup: inside prev"})
    map({"n", "x", "o"}, "z}", "<Plug>(matchup-z%)", {desc = "Matchup: inside next"})
    map({"n", "x", "o"}, "z%", "<Plug>(matchup-z%)", {desc = "Matchup: inside next"})

    map({"x", "o"}, "a5", "<Plug>(matchup-a%)", {desc = "Matchup: around any block"})
    map({"x", "o"}, "i5", "<Plug>(matchup-i%)", {desc = "Matchup: around any block"})

    -- FIX: This isn't working
    map("n", "ds%", "<Plug>(matchup-ds%)")
    map("n", "cs%", "<Plug>(matchup-cs%)")

    augroup(
        "lmb__Matchup",
        {
            event = "TermOpen",
            pattern = "*",
            command = function(args)
                local bufnr = args.buf
                vim.b[bufnr].matchup_matchparen_enabled = 0
                vim.b[bufnr].matchup_matchparen_fallback = 0
            end,
        },
        {
            event = "FileType",
            pattern = "qf",
            command = function(args)
                local bufnr = args.buf
                vim.b[bufnr].matchup_matchparen_enabled = 0
                vim.b[bufnr].matchup_matchparen_fallback = 0
            end,
        }
    )
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                       BetterEscape                       │
-- ╰──────────────────────────────────────────────────────────╯
function M.better_esc()
    local esc = F.npcall(require, "better_escape")
    if not esc then
        return
    end

    esc.setup({
        mapping = {"jk", "kj"}, -- a table with mappings to use
        -- timeout = vim.o.timeoutlen, -- the time in which the keys must be hit in ms. default = timeoutlen
        timeout = 375,
        clear_empty_lines = false, -- clear line after escaping if there is only whitespace
        keys = "<Esc>",
        -- keys = function()
        --   return Rc.api.get_cursor_col() > 1 and "<esc>l" or "<esc>"
        -- end,
    })
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                       SmartSplits                        │
-- ╰──────────────────────────────────────────────────────────╯
function M.smartsplits()
    -- local ss = F.npcall(require, "smart-splits")
    local ss = F.npcall(lazy.require_on.expcall, "smart-splits")
    if not ss then
        return
    end

    ss.setup({
        ignored_filetypes = {"nofile", "quickfix", "prompt"},
        ignored_buftypes = {"NvimTree"},
        ignored_events = {"BufEnter", "WinEnter"},
        -- when moving cursor between splits left or right,
        -- place the cursor on the same row of the *screen*
        -- regardless of line numbers. False by default.
        -- Can be overridden via function parameter, see Usage.
        move_cursor_same_row = false,
        default_amount = 3,
        cursor_follows_swapped_bufs = false,
        resize_mode = {
            quit_key = "<ESC>",
            resize_keys = {"h", "j", "k", "l"},
            silent = false,
            hooks = {
                on_enter = nil,
                on_leave = nil,
            },
        },
        multiplexer_integration = nil,
        disable_multiplexer_nav_when_zoomed = true,
        log_level = "fatal",
    })

    -- Can be achieved with custom function, but this has more functionality

    -- Move between windows
    wk.register({
        -- ["<C-j>"] = {F.ithunk(ss.move_cursor_down), "Move to below window"},
        -- ["<C-k>"] = {F.ithunk(ss.move_cursor_up), "Move to above window"},
        -- ["<C-h>"] = {F.ithunk(ss.move_cursor_left), "Move to left window"},
        -- ["<C-l>"] = {F.ithunk(ss.move_cursor_right), "Move to right window"},
        ["<C-Up>"] = {F.ithunk(ss.resize_up), "Resize window up"},
        ["<C-Down>"] = {F.ithunk(ss.resize_down), "Resize window down"},
        ["<C-Right>"] = {F.ithunk(ss.resize_right), "Resize window right"},
        ["<C-Left>"] = {F.ithunk(ss.resize_left), "Resize window left"},
    })
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                           tmux                           │
-- ╰──────────────────────────────────────────────────────────╯
function M.tmux()
    local tmux = F.npcall(lazy.require_on.expcall, "tmux")
    if not tmux then
        return
    end

    tmux.setup({
        copy_sync = {
            -- enables copy sync and overwrites all register actions to
            -- sync registers *, +, unnamed, and 0 till 9 from tmux in advance
            enable = false,
            -- ignore specific tmux buffers e.g. buffer0 = true to ignore the
            -- first buffer or named_buffer_name = true to ignore a named tmux
            -- buffer with name named_buffer_name :)
            ignore_buffers = {empty = false},
            -- TMUX >= 3.2: yanks (and deletes) will get redirected to system
            -- clipboard by tmux
            redirect_to_clipboard = true,
            -- offset controls where register sync starts
            -- e.g. offset 2 lets registers 0 and 1 untouched
            register_offset = 0,
            -- sync clipboard overwrites vim.g.clipboard to handle * and +
            -- registers. If you sync your system clipboard without tmux, disable
            -- this option!
            sync_clipboard = false,
            -- synchronizes registers *, +, unnamed, and 0 till 9 with tmux buffers.
            sync_registers = false,
            -- syncs deletes with tmux clipboard as well, it is adviced to
            -- do so. Nvim does not allow syncing registers 0 and 1 without
            -- overwriting the unnamed register. Thus, ddp would not be possible.
            sync_deletes = false,
            -- syncs the unnamed register with the first buffer entry from tmux.
            sync_unnamed = true,
        },
        navigation = {
            -- cycles to opposite pane while navigating into the border
            cycle_navigation = true,
            -- enables default keybindings (C-hjkl) for normal mode
            enable_default_keybindings = false,
            -- prevents unzoom tmux when navigating beyond vim border
            persist_zoom = true,
        },
        resize = {
            -- enables default keybindings (A-hjkl) for normal mode
            enable_default_keybindings = false,
            -- sets resize steps for x axis
            resize_step_x = 1,
            -- sets resize steps for y axis
            resize_step_y = 1,
        },
    })

    wk.register({
        ["<C-j>"] = {F.ithunk(tmux.move_bottom), "Move to below window/pane"},
        ["<C-k>"] = {F.ithunk(tmux.move_top), "Move to above window/pane"},
        ["<C-h>"] = {F.ithunk(tmux.move_left), "Move to left window/pane"},
        ["<C-l>"] = {F.ithunk(tmux.move_right), "Move to right window/pane"},
    })
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                        ScratchPad                        │
-- ╰──────────────────────────────────────────────────────────╯
function M.scratchpad()
    g.scratchpad_autostart = 0
    g.scratchpad_autosize = 0
    g.scratchpad_autofocus = 1
    g.scratchpad_textwidth = 80
    g.scratchpad_minwidth = 12
    g.scratchpad_location = "~/.cache/scratchpad"
    -- g.scratchpad_daily = 0
    -- g.scratchpad_daily_location = '~/.cache/scratchpad_daily.md'
    -- g.scratchpad_daily_format = '%Y-%m-%d'

    map("n", "<Leader>sc", "<cmd>lua require'scratchpad'.invoke()<CR>")
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                       Paperplanes                        │
-- ╰──────────────────────────────────────────────────────────╯
function M.paperplanes()
    -- paste.rs
    -- post_string(string, meta, cb)
    -- post_range(buffer, start, end, cb)
    -- post_selection(cb)
    -- post_buffer(buffer, cb)

    -- Command: PP

    local paperplanes = F.npcall(require, "paperplanes")
    if not paperplanes then
        return
    end

    paperplanes.setup({
        register = "+",
        provider = "paste.rs",
        provider_options = {},
        notifier = vim.notify,
        cmd = "curl",
    })
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                        Colorizer                         │
-- ╰──────────────────────────────────────────────────────────╯
function M.colorizer()
    local colorizer = F.npcall(require, "colorizer")
    if not colorizer then
        return
    end

    colorizer.setup({
        filetypes = {
            "conf",
            "css",
            "dosini",
            "gitconfig",
            "ini",
            "javascript",
            "json",
            "lua",
            "markdown",
            "noice",
            "python",
            "ron",
            "sh",
            "tmux",
            "toml",
            "typescript",
            "typescriptreact",
            "vim",
            "vimwiki",
            "xdefaults",
            "xml",
            "yaml",
            "zsh",
        },
        user_default_options = {
            RGB = true,                                -- #RGB hex codes
            RRGGBB = true,                             -- #RRGGBB hex codes
            RRGGBBAA = true,                           -- #RRGGBBAA hex codes
            AARRGGBB = true,                           -- 0xAARRGGBB hex codes
            names = false,                             -- "Name" codes like Blue
            -- rgb_0x = false, -- 0xAARRGGBB hex codes
            rgb_fn = true,                             -- CSS rgb() and rgba() functions
            hsl_fn = true,                             -- CSS hsl() and hsla() functions
            css = false,                               -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
            css_fn = false,                            -- Enable all CSS *functions*: rgb_fn, hsl_fn
            -- Available modes for `mode`: foreground, background, virtualtext
            mode = "background",                       -- Set the display mode.
            -- Available methods are false / true / "normal" / "lsp" / "both"
            tailwind = true,                           -- Enable tailwind colors
            -- parsers can contain values used in |user_default_options|
            sass = {enable = true, parsers = {"css"}}, -- Enable sass colors
            virtualtext = "■",
            -- update color values even if buffer is not focused
            always_update = true,
        },
        -- all the sub-options of filetypes apply to buftypes
        buftypes = {"nofile"},
    })
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                         Grepper                          │
-- ╰──────────────────────────────────────────────────────────╯
function M.grepper()
    g.grepper = {
        dir = "repo,file",
        simple_prompt = 1,
        searchreg = 1,
        stop = 50000,
        tools = {"rg", "git"},
        rg = {
            grepprg = utils.list({
                "rg",
                "--with-filename",
                "--no-heading",
                "--max-columns=200",
                "--vimgrep",
                "--smart-case",
                "--color=never",
                "--follow",
                "--pcre2",
            }, " "),
            grepformat = "%f:%l:%c:%m,%f:%l:%m",
        },
    }

    map("n", "gs", "<Plug>(GrepperOperator)", {desc = "Grep project: operator"})
    map("x", "gs", "<Plug>(GrepperOperator)", {desc = "Grep project: operator"})
    map("n", "gsw", "<Plug>(GrepperOperator)iw", {desc = "Grep project: word"})
    map("n", "<Leader>rg", [[<Cmd>Grepper<CR>]], {desc = "Grep project: command"})

    command(
        "Grep",
        [[Grepper -noprompt -query <q-args>]],
        {nargs = 1, desc = "Grep current directory"}
    )
    command(
        "LGrep",
        [[Grepper -noprompt -noquickfix -query <q-args>]],
        {nargs = 1, desc = "Grep current directory (loclist)"}
    )
    command(
        "GrepBuf",
        [[Grepper -noprompt -buffer -query <q-args>]],
        {nargs = 1, desc = "Grep current buffer"}
    )
    command(
        "LGrepBuf",
        [[Grepper -noprompt -noquickfix -buffer -query <q-args>]],
        {nargs = 1, desc = "Grep current buffer (loclist)"}
    )
    command(
        "GrepBufs",
        [[Grepper -noprompt -buffers -query <q-args>]],
        {nargs = 1, desc = "Grep open buffer"}
    )
    command(
        "LGrepBufs",
        [[Grepper -noprompt -noquickfix -buffers -query <q-args>]],
        {nargs = 1, desc = "Grep open buffers (loclist)"}
    )
    -- command(
    --     "GitGrep",
    --     [[Grepper -noprompt -tool git -query <q-args>]],
    --     {nargs = 1, desc = "Grep git repo"}
    -- )

    augroup(
        "Grepper",
        {
            event = "User",
            pattern = "Grepper",
            nested = true,
            command = function()
                -- \%# = cursor position
                fn.setqflist({}, "r", {context = {bqf = {pattern_hl = [[\%#]] .. nvim.reg["/"]}}})
            end,
        }
    )
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                        Registers                         │
-- ╰──────────────────────────────────────────────────────────╯
function M.registers()
    local registers = F.npcall(require, "registers")
    if not registers then
        return
    end

    registers.setup(
        {
            show = '*+"-/_=#%.0123456789abcdefghijklmnopqrstuvwxyz:',
            show_empty = true,
            register_user_command = true,
            system_clipboard = true,
            trim_whitespace = true,
            hide_only_whitespace = true,
            show_register_types = true,
            bind_keys = {
                normal = registers.show_window({mode = "motion"}),
                visual = registers.show_window({mode = "motion"}),
                insert = registers.show_window({mode = "insert"}),
                registers = registers.apply_register({delay = 0.1}),
                return_key = registers.apply_register(),
                escape = registers.close_window(),
                ctrl_n = registers.move_cursor_down(),
                ctrl_p = registers.move_cursor_up(),
                ctrl_j = registers.move_cursor_down(),
                ctrl_k = registers.move_cursor_up(),
                -- Clear the register of the highlighted line when pressing <DEL>
                delete = registers.clear_highlighted_register(),
                -- Clear the register of the highlighted line when pressing <BS>
                backspace = registers.clear_highlighted_register(),
            },
            events = {
                -- When a register line is highlighted, show a preview in the main buffer with how
                -- the register will be applied, but only if the register will be inserted or pasted
                on_register_highlighted = registers.preview_highlighted_register(
                    {if_mode = {"insert", "paste"}}
                ),
            },
            symbols = {
                newline = "⏎",
                space = " ",
                tab = "‣",
                register_type_charwise = "ᶜ",
                register_type_linewise = "ˡ",
                register_type_blockwise = "ᵇ",
            },
            window = {
                max_width = 100,
                highlight_cursorline = true,
                border = Rc.style.border,
                transparency = 10,
            },
            sign_highlights = {
                cursorline = "Visual",
                selection = "Constant",
                default = "Function",
                unnamed = "Statement",
                read_only = "Type",
                expression = "Exception",
                black_hole = "Error",
                alternate_buffer = "Operator",
                last_search = "Tag",
                delete = "Special",
                yank = "Delimiter",
                history = "Number",
                named = "Todo",
            },
        }
    )
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                            LF                            │
-- ╰──────────────────────────────────────────────────────────╯
function M.lf()
    g.lf_map_keys = 0
    g.lf_replace_netrw = 0

    map("n", "<C-A-u>", ":Lf<CR>")
end

function M.lfnvim()
    local lf = F.npcall(require, "lf")
    if not lf then
        return
    end

    g.lf_netrw = 0

    lf.setup({
        escape_quit = true,
        focus_on_open = true,
        border = Rc.style.border,
        highlights = {
            NormalFloat = {link = "Normal"},
            FloatBorder = {link = "@constant"},
        },
    })

    map("n", "<A-o>", ":Lfnvim<CR>")
    -- map("n", "<A-y>", ":Lf<CR>")
    -- map("n", "<A-o>", ":Lfnvim<CR>")
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                       LinkVisitor                        │
-- ╰──────────────────────────────────────────────────────────╯
function M.link_visitor()
    local lv = F.npcall(lazy.require_on.expcall, "link-visitor")
    if not lv then
        return
    end

    lv.setup({
        open_cmd = "handlr open",
        silent = true,             -- disable all prints
        skip_confirmation = false, -- Skip the confirmation step, default: false
    })

    map("n", "<Leader>gf", "require('usr.lib.fn').open_path()",
        {lcmd = true, desc = "Link: under cursor"})
    map("n", "gX", F.ithunk(lv.link_under_cursor), {desc = "Link: under cursor"})
    map("n", "gw", F.ithunk(lv.link_near_cursor), {desc = "Link: near cursor"})
    -- map("n", "gX", F.ithunk(lv.link_nearest), {desc = "Link: nearest"})

    local function link_visitor_map(bufnr)
        Rc.api.bmap(bufnr, "n", "K", F.ithunk(lv.link_under_cursor), {desc = "Link: under cursor"})
        Rc.api.bmap(bufnr, "n", "M", F.ithunk(lv.link_near_cursor), {desc = "Link: near cursor"})
    end

    augroup(
        "lmb__LinkVisitor",
        {
            event = "User",
            pattern = "CocOpenFloat",
            command = function()
                local winid = g.coc_last_float_win
                if winid and api.nvim_win_is_valid(winid) then
                    local bufnr = api.nvim_win_get_buf(winid)
                    api.nvim_buf_call(
                        bufnr,
                        function()
                            link_visitor_map(bufnr)
                        end
                    )
                end
            end,
        },
        {
            event = "WinEnter",
            pattern = "*",
            command = function(args)
                local bufnr = args.buf
                if vim.bo[bufnr].ft == "crates.nvim" then
                    api.nvim_buf_call(
                        bufnr,
                        function()
                            link_visitor_map(bufnr)
                        end
                    )
                end
            end,
        }
    )
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                         urlview                          │
-- ╰──────────────────────────────────────────────────────────╯
function M.urlview()
    local urlview = F.npcall(require, "urlview")
    if not urlview then
        return
    end

    local actions = require("urlview.actions")
    actions["handlr"] = function(raw_url)
        fn.system(("handlr open %q"):format(raw_url))
    end

    urlview.setup(
        {
            -- Prompt title (`<context> <default_title>`, e.g. `Buffer Links:`)
            default_title = "Links:",
            -- Default picker to display links with
            -- Options: "native" (vim.ui.select) or "telescope"
            default_picker = "native",
            -- Set the default protocol for us to prefix URLs with if they don't start with http/https
            default_prefix = "https://",
            -- Command or method to open links with
            -- Options: "netrw", "system" (default OS browser); or "firefox", "chromium" etc.
            -- By default, this is "netrw", or "system" if netrw is disabled
            default_action = "handlr", -- "clipboard",
            -- Ensure links shown in the picker are unique (no duplicates)
            unique = true,
            -- Ensure links shown in the picker are sorted alphabetically
            sorted = true,
            -- Minimum log level (recommended at least `vim.log.levels.WARN` for error detection warnings)
            log_level_min = log.levels.INFO,
            -- Keymaps for jumping to previous / next URL in buffer
            jump = {
                prev = "[u",
                next = "]u",
            },
        }
    )

    wk.register({
        ["[u"] = "Previous URL",
        ["]u"] = "Next URL",
    })

    -- Examples:
    -- :UrlView buffer bufnr=1
    -- :UrlView file filepath=/etc/hosts picker=telescope
    -- :UrlView packer sorted=false
    map("n", "<LocalLeader>x", "UrlView", {cmd = true})
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                         DevIcons                         │
-- ╰──────────────────────────────────────────────────────────╯
function M.devicons()
    local devicons = F.npcall(require, "nvim-web-devicons")
    if not devicons then
        return
    end

    devicons.set_icon({
        scratchpad = {
            icon = "",
            color = "#6d8086",
            name = "Scratchpad",
        },
        NeogitStatus = {
            icon = "",
            color = "#F14C28",
            name = "BranchCycle",
        },
        DiffviewFiles = {
            icon = "",
            color = "#F14C28",
            name = "TelescopePrompt",
        },
        org = {
            icon = "◉",
            color = "#75A899",
            name = "Org",
        },
        sol = {
            icon = "♦",
            color = "#a074c4",
            name = "Sol",
        },
        sh = {
            icon = "",
            color = "#89e051",
            cterm_color = "113",
            name = "Sh",
        },
    })
end

--  ╭──────────────────────────────────────────────────────────╮
--  │                        NerdIcons                         │
--  ╰──────────────────────────────────────────────────────────╯
function M.nerdicons()
    local nerd = F.npcall(require, "nerdicons")
    if not nerd then
        return
    end

    nerd.setup({
        border = Rc.style.border, -- Border
        prompt = " ",          -- Prompt Icon
        preview_prompt = " ",  -- Preview Prompt Icon
        up = "<C-k>",             -- Move up in preview
        down = "<C-j>",           -- Move down in preview
        copy = "<C-y>",           -- Copy to the clipboard
    })
end

--  ╭──────────────────────────────────────────────────────────╮
--  │                          Fundo                           │
--  ╰──────────────────────────────────────────────────────────╯
function M.fundo()
    local fundo = F.npcall(require, "fundo")
    if not fundo then
        return
    end

    fundo.setup({
        archives_dir = ("%s/%s"):format(Rc.dirs.cache, "fundo"),
        limit_archives_size = 512,
    })
end

--  ╭──────────────────────────────────────────────────────────╮
--  │                           CCLS                           │
--  ╰──────────────────────────────────────────────────────────╯
function M.ccls()
    g.ccls_close_on_jump = true
    g.ccls_levels = 1
    g.ccls_size = 50
    g.ccls_position = "botright"
    g.ccls_orientation = "horizontal"
    g.ccls_float_width = 50
    g.ccls_float_height = 20
    g.yggdrasil_no_default_maps = 1

    nvim.autocmd.lmb__Ccls = {
        event = "FileType",
        pattern = "yggdrasil",
        command = function(_a)
            local bmap = function(...)
                Rc.api.bmap(0, ...)
            end
            bmap("n", "o", "<Plug>(yggdrasil-toggle-node)", {desc = "Toggle CCLS tree"})
            bmap("n", "O", "<Plug>(yggdrasil-open-node)", {desc = "Open CCLS tree"})
            bmap("n", "Q", "<Plug>(yggdrasil-close-node)", {desc = "Close CCLS tree"})
            bmap("n", "<CR>", "<Plug>(yggdrasil-execute-node)", {desc = "Execute CCLS node"})
            bmap("n", "qq", ":q<CR>", {desc = "Close CCLS window"})
        end,
    }
end

return M
