---Contains colorscheme information (named after the colorscheme I use the most)
--@module kimbox
--@author Lucas Burns

local M = {}

local utils = require("common.utils")
local augroup = utils.augroup
local autocmd = utils.autocmd

local color = require("common.color")
local hl = color.set_hl

-- General configurations for various themes

M.catppuccin = function()
    local catppuccin = require("catppuccin")
    catppuccin.setup(
        {
            transparent_background = false,
            term_colors = false,
            styles = {
                comments = "italic",
                functions = "bold",
                keywords = "none",
                strings = "none",
                variables = "none"
            }
        }
    )

    local cp = require("catppuccin.api.colors").get_colors()
    local inactive_bg = cp.black1

    catppuccin.after_loading = function()
        -- This still needs fixed a little more
        hl("BufferLineNumbers", {guifg = cp.white, guibg = inactive_bg})
        hl("BufferLineNumbersVisible", {guifg = cp.white, guibg = inactive_bg})
        hl("BufferLineNumbersSelected", {guifg = cp.red, guibg = cp.black4})

        hl("BufferLineModified", {guifg = cp.white, guibg = inactive_bg})
        hl("BufferLineModifiedVisible", {guifg = cp.white, guibg = inactive_bg})
        hl("BufferLineModifiedSelected", {guifg = cp.red, guibg = cp.black4})

        hl("BufferLineDiagnostic", {guifg = cp.white, guibg = inactive_bg})
        hl("BufferLineDiagnosticVisible", {guifg = cp.white, guibg = inactive_bg})
        hl("BufferLineDiagnosticSelected", {guifg = cp.rd, guibg = cp.black4})

        hl("BufferLineHintDiagnostic", {guifg = cp.white, guibg = inactive_bg})
        hl("BufferLineHintDiagnosticVisible", {guifg = cp.white, guibg = inactive_bg})
        hl("BufferLineHintDiagnosticSelected", {guifg = cp.red, guibg = cp.black4})

        hl("BufferLineInfoDiagnostic", {guifg = cp.white, guibg = inactive_bg})
        hl("BufferLineInfoDiagnosticVisible", {guifg = cp.white, guibg = inactive_bg})
        hl("BufferLineInfoDiagnosticSelected", {guifg = cp.red, guibg = cp.black4})

        hl("BufferLineWarningDiagnostic", {guifg = cp.white, guibg = inactive_bg})
        hl("BufferLineWarningDiagnosticVisible", {guifg = cp.white, guibg = inactive_bg})
        hl("BufferLineWarningDiagnosticSelected", {guifg = cp.red, guibg = cp.black4})

        hl("BufferLineErrorDiagnostic", {guifg = cp.white, guibg = inactive_bg})
        hl("BufferLineErrorDiagnosticVisible", {guifg = cp.white, guibg = inactive_bg})
        hl("BufferLineErrorDiagnosticSelected", {guifg = cp.red, guibg = cp.black4})

        hl("BufferLineHint", {guifg = cp.white, guibg = inactive_bg})
        hl("BufferLineHintVisible", {guifg = cp.white, guibg = inactive_bg})
        hl("BufferLineHintSelected", {guifg = cp.red, guibg = cp.black4})

        hl("BufferLineInfo", {guifg = cp.white, guibg = inactive_bg})
        hl("BufferLineInfoVisible", {guifg = cp.white, guibg = inactive_bg})
        hl("BufferLineInfoSelected", {guifg = cp.red, guibg = cp.black4})

        hl("BufferLineWarning", {guifg = cp.white, guibg = inactive_bg})
        hl("BufferLineWarningVisible", {guifg = cp.white, guibg = inactive_bg})
        hl("BufferLineWarningSelected", {guifg = cp.red, guibg = cp.black4})

        hl("BufferLineError", {guifg = cp.white, guibg = inactive_bg})
        hl("BufferLineErrorVisible", {guifg = cp.white, guibg = inactive_bg})
        hl("BufferLineErrorSelected", {guifg = cp.red, guibg = cp.black4})

        hl("BufferLineFill", {guifg = inactive_bg})
        hl("BufferLineBackground", {guifg = cp.white, guibg = inactive_bg})
        hl("BufferLineBufferVisible", {guifg = cp.mauve, guibg = cp.black4})
        hl("BufferLineBufferSelected", {guifg = cp.mauve, guibg = cp.black4, gui = "bold,italic"})

        hl("BufferLineTab", {guifg = cp.mauve, guibg = inactive_bg})
        hl("BufferLineTabSelected", {guifg = cp.white, guibg = cp.black4})
        hl("BufferLineTabClose", {guifg = cp.white, guibg = cp.black4})

        hl("BufferLineIndicatorSelected", {guifg = cp.maroon, guibg = cp.black4})
        hl("BufferLineSeparator", {guifg = inactive_bg, guibg = cp.black4})
        hl("BufferLineSeparatorVisible", {guifg = inactive_bg, guibg = cp.black4})
        hl("BufferLineSeparatorSelected", {guifg = inactive_bg, guibg = cp.black4})

        ex.hi("TSMethod gui=bold")
        ex.hi("TSVariableBuiltin gui=none")
        ex.hi("TSTypeBuiltin gui=none")
        ex.hi("TSProperty gui=none")
        ex.hi("TSVariable gui=none")
        ex.hi("TSFunction gui=bold")
        ex.hi("TSFuncBuiltin gui=bold")
        ex.hi("TSParameter gui=none")
        -- ex.hi("TSNamespace gui=none")
        ex.hi("Function gui=bold")
        ex.hi("Todo guibg=none")
    end

    -- cmd [[colorscheme catppuccin]]
end

M.kanagawa = function()
    local cp = require("kanagawa.colors").setup()

    local bg = cp.waveBlue2
    local ibg = cp.sumiInk1

    local overrides = {
        BufferLineFill = {bg = ibg},
        BufferLineBackground = {fg = cp.fujiWhite, bg = ibg}, -- others
        BufferLineBufferVisible = {fg = cp.sumiInk0, bg = cp.sumiInk4},
        BufferLineBufferSelected = {fg = cp.fujiWhite, bg = cp.sumiInk4, style = "bold,italic"}, -- current
        --
        BufferLineTab = {fg = cp.sumiInk0, bg = cp.ibg},
        BufferLineTabSelected = {fg = cp.fujiWhite, bg = cp.sumiInk4},
        BufferLineTabClose = {fg = cp.fujiWhite, bg = ibg},
        --
        BufferLineIndicatorSelected = {fg = cp.samuraiRed, bg = cp.sumiInk4},
        BufferLineSeparator = {fg = ibg, bg = ibg},
        BufferLineSeparatorVisible = {fg = ibg, bg = cp.sumiInk4},
        BufferLineSeparatorSelected = {fg = ibg, bg = cp.sumiInk4},
        --
        BufferLineNumbers = {fg = cp.fujiWhite, bg = ibg},
        BufferLineNumbersVisible = {fg = cp.fujiWhite, bg = cp.sumiInk4},
        BufferLineNumbersSelected = {fg = cp.fujiWhite, bg = cp.sumiInk4},
        --
        BufferLineModified = {fg = cp.white, bg = ibg},
        BufferLineModifiedVisible = {fg = cp.white, bg = cp.sumiInk4},
        BufferLineModifiedSelected = {fg = cp.white, bg = cp.sumiInk4},
        --
        BufferLineDiagnostic = {fg = cp.fujiWhite, bg = ibg},
        BufferLineDiagnosticVisible = {fg = cp.fujiWhite, bg = cp.sumiInk4},
        BufferLineDiagnosticSelected = {fg = cp.fujiWhite, bg = cp.sumiInk4},
        --
        BufferLineHintDiagnostic = {fg = cp.fujiWhite, bg = ibg},
        BufferLineHintDiagnosticVisible = {fg = cp.fujiWhite, bg = cp.sumiInk4},
        BufferLineHintDiagnosticSelected = {fg = cp.fujiWhite, bg = cp.sumiInk4},
        --
        BufferLineInfoDiagnostic = {fg = cp.fujiWhite, bg = ibg},
        BufferLineInfoDiagnosticVisible = {fg = cp.fujiWhite, bg = cp.sumiInk4},
        BufferLineInfoDiagnosticSelected = {fg = cp.fujiWhite, bg = cp.sumiInk4},
        --
        BufferLineWarningDiagnostic = {fg = cp.fujiWhite, bg = ibg},
        BufferLineWarningDiagnosticVisible = {fg = cp.fujiWhite, bg = cp.sumiInk4},
        BufferLineWarningDiagnosticSelected = {fg = cp.fujiWhite, bg = cp.sumiInk4},
        --
        BufferLineErrorDiagnostic = {fg = cp.fujiWhite, bg = ibg},
        BufferLineErrorDiagnosticVisible = {fg = cp.fujiWhite, bg = cp.sumiInk4},
        BufferLineErrorDiagnosticSelected = {fg = cp.fujiWhite, bg = cp.sumiInk4},
        --
        BufferLineHint = {fg = cp.fujiWhite, bg = ibg},
        BufferLineHintVisible = {fg = cp.fujiWhite, bg = cp.sumiInk4},
        BufferLineHintSelected = {fg = cp.fujiWhite, bg = cp.sumiInk4},
        --
        BufferLineInfo = {fg = cp.fujiWhite, bg = ibg},
        BufferLineInfoVisible = {fg = cp.fujiWhite, bg = cp.sumiInk4},
        BufferLineInfoSelected = {fg = cp.fujiWhite, bg = cp.sumiInk4},
        --
        BufferLineWarning = {fg = cp.fujiWhite, bg = ibg},
        BufferLineWarningVisible = {fg = cp.fujiWhite, bg = cp.sumiInk4},
        BufferLineWarningSelected = {fg = cp.fujiWhite, bg = cp.sumiInk4},
        --
        BufferLineError = {fg = cp.fujiWhite, bg = ibg},
        BufferLineErrorVisible = {fg = cp.fujiWhite, bg = cp.sumiInk4},
        BufferLineErrorSelected = {fg = cp.fujiWhite, bg = cp.sumiInk4}
    }

    require("kanagawa").setup(
        {
            undercurl = true, -- enable undercurls
            commentStyle = "italic",
            functionStyle = "bold",
            keywordStyle = "NONE",
            statementStyle = "NONE",
            typeStyle = "bold",
            variablebuiltinStyle = "italic",
            specialReturn = true, -- special highlight for the return keyword
            specialException = true, -- special highlight for exception handling keywords
            transparent = false, -- do not set background color
            dimInactive = false, -- dim inactive window `:h hl-NormalNC`
            globalStatus = false, -- adjust window separators highlight for laststatus=3
            colors = {},
            overrides = overrides
        }
    )

    -- cmd [[colorscheme kanagawa]]
end

M.nightfox = function()
    require("nightfox").setup(
        {
            options = {
                -- Compiled file's destination location
                compile_path = fn.stdpath("cache") .. "/nightfox",
                compile_file_suffix = "_compiled", -- Compiled file suffix
                transparent = false, -- Disable setting background
                terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
                dim_inactive = false, -- Non focused panes set to alternative background
                styles = {
                    -- Style to be applied to different syntax groups
                    comments = "none", -- Value is any valid attr-list value `:help attr-list`
                    functions = "bold",
                    keywords = "bold",
                    numbers = "NONE",
                    strings = "NONE",
                    types = "NONE",
                    variables = "NONE"
                },
                inverse = {
                    -- Inverse highlight for different types
                    match_paren = true,
                    visual = false,
                    search = false
                },
                modules = {}
            }
        }
    )

    -- nordfox duskfox terafxo
    -- cmd [[colorscheme nightfox]]
end

-- === Gruvbox ===
M.gruvbox = function()
    g.gruvbox_material_background = "medium"
    -- g.gruvbox_material_background = "hard"
    g.gruvbox_material_palette = "mix"
    g.gruvbox_material_palette = "material"
    g.gruvbox_material_enable_bold = 1
    g.gruvbox_material_disable_italic_comment = 1
    g.gruvbox_material_current_word = "grey background"
    g.gruvbox_material_visual = "grey background"
    g.gruvbox_material_cursor = "green"
    g.gruvbox_material_sign_column_background = "none"
    g.gruvbox_material_statusline_style = "mix"
    g.gruvbox_material_better_performance = 1
    g.gruvbox_material_diagnostic_text_highlight = 0
    g.gruvbox_material_diagnostic_line_highlight = 0
    g.gruvbox_material_diagnostic_virtual_text = "colored"

    -- cmd [[colorscheme gruvbox-material]]
end

-- === Gruvbox-Flat ===
M.gruvbox_flat = function()
    g.gruvbox_italic_functions = true
    g.gruvbox_sidebars = {"qf", "vista_kind", "terminal", "packer"}
end

-- === Oceanic ===
M.ocean_material = function()
    g.oceanic_material_background = "ocean"
    -- g.oceanic_material_background = "deep"
    -- g.oceanic_material_background = "medium"
    -- g.oceanic_material_background = "darker"
    g.oceanic_material_allow_bold = 1
    g.oceanic_material_allow_italic = 0
    g.oceanic_material_allow_underline = 1

    -- cmd [[colorscheme oceanic_material]]
end

-- === Everforest ===
M.everforest = function()
    g.everforest_disable_italic_comment = 1
    g.everforest_background = "hard"
    g.everforest_enable_italic = 0
    g.everforest_enable_bold = 1
    g.everforest_sign_column_background = "none"
    g.everforest_better_performance = 1

    -- cmd [[colorscheme everforest]]
end

-- === Edge ===
M.edge = function()
    g.edge_style = "aura"
    g.edge_cursor = "blue"
    g.edge_sign_column_background = "none"
    g.edge_better_performance = 1

    -- cmd [[colorscheme edge]]
end

-- === Sonokai ===
M.sonokai = function()
    -- maia atlantis era
    -- g.sonokai_style = 'andromeda'
    g.sonokai_style = "shusia"
    g.sonokai_enable_italic = 1
    g.sonokai_disable_italic_comment = 1
    g.sonokai_cursor = "blue"
    g.sonokai_sign_column_background = "none"
    g.sonokai_better_performance = 1
    g.sonokai_diagnostic_text_highlight = 0

    -- cmd [[colorscheme sonokai]]
end

-- === Miramare ===
M.miramare = function()
    g.miramare_enable_bold = 1
    g.miramare_disable_italic_comment = 1
    g.miramare_cursor = "purple"
    g.miramare_current_word = "grey background"

    -- cmd [[colorscheme miramare]]
end

-- === Material ===
M.material = function()
    g.material_style = "deep ocean"
    -- g.material_style = "palenight"
    -- g.material_style = "darker"
    require("material").setup(
        {
            contrast = {
                sidebars = false, -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
                floating_windows = false, -- Enable contrast for floating windows
                line_numbers = false, -- Enable contrast background for line numbers
                sign_column = false, -- Enable contrast background for the sign column
                cursor_line = false, -- Enable darker background for the cursor line
                non_current_windows = false, -- Enable darker background for non-current windows
                popup_menu = false -- Enable lighter background for the popup menu
            },
            italics = {
                comments = false, -- Enable italic comments
                keywords = false, -- Enable italic keywords
                functions = false, -- Enable italic functions
                strings = false, -- Enable italic strings
                variables = false -- Enable italic variables
            },
            contrast_filetypes = {
                -- Specify which filetypes get the contrasted (darker) background
                "terminal", -- Darker terminal background
                "packer", -- Darker packer background
                "qf" -- Darker qf list background
            },
            high_visibility = {
                lighter = false, -- Enable higher contrast text for lighter style
                darker = false -- Enable higher contrast text for darker style
            },
            disable = {
                borders = false, -- Disable borders between verticaly split windows
                background = false, -- Prevent the theme from setting the background (NeoVim then uses your teminal background)
                term_colors = false, -- Prevent the theme from setting terminal colors
                eob_lines = false -- Hide the end-of-buffer lines
            },
            lualine_style = "default", -- Lualine style ( can be 'stealth' or 'default' )
            async_loading = true, -- Load parts of the theme asyncronously for faster startup (turned on by default)
            custom_highlights = {} -- Overwrite highlights with your own
        }
    )
end

M.tokyonight = function()
    -- === Tokyo Night ===
    -- g.tokyonight_style = "storm" -- night day storm
    g.tokyonight_style = "night" -- night day storm
    g.tokyonight_italic_comments = false
    g.tokyonight_italic_keywords = false
    g.tokyonight_italic_functions = false
    g.tokyonight_sidebars = {"qf", "vista_kind", "terminal", "packer"}

    -- hl("Function", {gui=bold})
    -- cmd("hi Function gui=bold")

    -- cmd [[colorscheme tokyonight]]
end

-- === VSCode ===
M.vscode = function()
    g.vscode_style = "dark"
    g.vscode_transparent = 0
    g.vscode_italic_comment = 0
end

-- === OneDark ===
M.onedark = function()
    local od = require("onedarkpro")
    od.setup(
        {
            -- Theme can be overwritten with 'onedark' or 'onelight' as a string
            theme = "onedark",
            colors = {}, -- Override default colors by specifying colors for 'onelight' or 'onedark' themes
            hlgroups = {}, -- Override default highlight groups
            filetype_hlgroups = {}, -- Override default highlight groups for specific filetypes
            plugins = {
                -- Override which plugins highlight groups are loaded
                native_lsp = true,
                polygot = true,
                treesitter = true
                -- NOTE: Other plugins have been omitted for brevity
            },
            styles = {
                strings = "NONE", -- Style that is applied to strings
                comments = "NONE", -- Style that is applied to comments
                keywords = "NONE", -- Style that is applied to keywords
                functions = "NONE", -- Style that is applied to functions
                variables = "NONE", -- Style that is applied to variables
                virtual_text = "NONE" -- Style that is applied to virtual text
            },
            options = {
                bold = false, -- Use the themes opinionated bold styles?
                italic = false, -- Use the themes opinionated italic styles?
                underline = false, -- Use the themes opinionated underline styles?
                undercurl = false, -- Use the themes opinionated undercurl styles?
                cursorline = false, -- Use cursorline highlighting?
                transparency = false, -- Use a transparent background?
                terminal_colors = false, -- Use the theme's colors for Neovim's :terminal?
                window_unfocussed_color = false -- When the window is out of focus, change the normal background?
            }
        }
    )

    -- od.load()
end

-- === OneNord ===
M.onenord = function()
    require("onenord").setup(
        {
            theme = "dark", -- "dark" or "light". Alternatively, remove the option and set vim.o.background instead
            borders = true, -- Split window borders
            fade_nc = false, -- Fade non-current windows, making them more distinguishable
            styles = {
                comments = "NONE", -- Style that is applied to comments: see `highlight-args` for options
                strings = "NONE", -- Style that is applied to strings: see `highlight-args` for options
                keywords = "NONE", -- Style that is applied to keywords: see `highlight-args` for options
                functions = "bold", -- Style that is applied to functions: see `highlight-args` for options
                variables = "NONE", -- Style that is applied to variables: see `highlight-args` for options
                diagnostics = "underline" -- Style that is applied to diagnostics: see `highlight-args` for options
            },
            disable = {
                background = false, -- Disable setting the background color
                cursorline = false, -- Disable the cursorline
                eob_lines = true -- Hide the end-of-buffer lines
            },
            custom_highlights = {}, -- Overwrite default highlight groups
            custom_colors = {} -- Overwrite default colors
        }
    )
end

-- === NightFly ===
M.nightfly = function()
    g.nightflyItalics = 0
end

-- === Leaf ===
-- M.leaf = function()
--     require("leaf").setup(
--         {
--             undercurl = true,
--             commentStyle = "NONE",
--             functionStyle = "bold",
--             keywordStyle = "none",
--             statementStyle = "bold",
--             typeStyle = "NONE",
--             variablebuiltinStyle = "none",
--             transparent = false,
--             colors = {},
--             overrides = {},
--             theme = "dark" -- default, alternatives: "dark", "lighter", "darker", "lightest", "darkest"
--         }
--     )
-- end

-- === Kimbox ===
M.kimbox = function()
    ex.packadd("kimbox")
    require("kimbox").setup(
        {
            style = "ocean",
            allow_bold = true,
            allow_italic = false,
            allow_underline = false,
            allow_undercurl = false,
            allow_reverse = false,
            term_colors = true,
            popup = {
                background = false -- use background color for pmenu
            },
            toggle_style_list = require("kimbox").bgs_list
        }
    )
    -- require("kimbox").load()
end

local function init()
    local colorscheme = ex.colorscheme

    nvim.autocmd.LushTheme = {
        event = "BufWritePost",
        pattern = "*/lua/lush_theme/*.lua",
        command = function()
            require("plugs.lush").write_post()
        end
    }

    M.kimbox()
    M.gruvbox()
    M.gruvbox_flat()
    M.everforest()
    M.ocean_material()
    M.miramare()
    M.tokyonight()
    M.kanagawa()
    M.catppuccin()
    M.material()
    M.nightfox()
    M.edge()
    M.onenord()
    -- M.leaf()
    -- M.vscode()

    -- require("kimbox").load()
    --
    -- local theme = "jellybeans"
    -- local theme = "lmspacegray"
    -- local theme = "one"
    --
    -- local theme = "gruvbox-material"
    -- local theme = "spaceduck"
    -- local theme = "everforest"
    -- local theme = "onenord"
    -- local theme = "material"
    -- local theme = "catppuccin"
    -- local theme = "tokyonight"
    -- local theme = "kanagawa"
    local theme = "kimbox"

    if not pcall(colorscheme, theme) then
        if uv.fs_stat(("%s/%s/%s.lua"):format(fn.stdpath("config"), "lua/lush_theme", theme)) then
            require("plugs.lush").dump(theme)
        -- else
        --     log.err("theme file does not exist")
        end
    end
end

init()

return M
