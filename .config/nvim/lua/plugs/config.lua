---Contains configuration items for plugins that don't deserve their own file
--@module config
--@author lmburns

local M = {}

local utils = require("common.utils")

local wk = require("which-key")
local map = utils.map
local command = utils.command
local C = require("common.color")

local augroup = utils.augroup
local autocmd = utils.autocmd

local ex = nvim.ex
local fn = vim.fn
local g = vim.g
local b = vim.bo

-- ╭──────────────────────────────────────────────────────────╮
-- │                           bqf                            │
-- ╰──────────────────────────────────────────────────────────╯
function M.bqf()
    -- FIX: Sometimes preview window is transparent
    C.link("BqfPreviewBorder", "Parameter")

    require("bqf").setup(
        {
            auto_enable = true,
            auto_resize_height = true,
            preview = {auto_preview = true, delay_syntax = 50},
            func_map = {
                split = "<C-s>",
                drop = "o",
                openc = "O",
                tabdrop = "<C-t>",
                pscrollup = "<C-u>",
                pscrolldown = "<C-d>",
                ptogglemode = "z,",
                fzffilter = "zf",
                filter = "zn",
                filterr = "zN"
            },
            filter = {
                fzf = {
                    action_for = {
                        ["enter"] = "drop",
                        ["ctrl-s"] = "split",
                        ["ctrl-t"] = "tab drop",
                        ["ctrl-x"] = ""
                    },
                    extra_opts = {"--delimiter", "│"}
                }
            }
        }
    )
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                         Listish                          │
-- ╰──────────────────────────────────────────────────────────╯
function M.listish()
    require("listish").config(
        {
            theme_list = false,
            clearqflist = "Clearquickfix", -- command
            clearloclist = "Clearloclist", -- command
            clear_notes = "ClearListNotes", -- command
            lists_close = "<Nop>", -- closes both qf/local lists
            in_list_dd = "dd", -- delete current item in the list
            quickfix = {
                open = "qo",
                on_cursor = "qa", -- add current position to the list
                add_note = "qn", -- add current position with your note to the list
                clear = "qi", -- clear all items
                close = "<Nop>",
                next = "<Nop>",
                prev = "<Nop>"
            },
            locallist = {
                open = "<Leader>wo",
                on_cursor = "<leader>wa",
                add_note = "<leader>wn",
                clear = "<Leader>wi",
                close = "<Nop>",
                next = "]w",
                prev = "[w"
            }
        }
    )

    wk.register(
        {
            ["]e"] = {":cnewer<CR>", "Next quickfix list"},
            ["[e"] = {":colder<CR>", "Previous quickfix list"},
            ["]w"] = "Next item in loclist",
            ["[w"] = "Previous item in loclist"
        }
    )

    wk.register(
        {
            q = {
                name = "+quickfix",
                o = "Quickfix open",
                a = "Quickfix add current line",
                n = "Quickfix add note",
                i = "Quickfix clear items"
            }
        }
    )

    ex.pa("cfilter")
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                       PackageInfo                        │
-- ╰──────────────────────────────────────────────────────────╯
function M.package_info()
    require("package-info").setup(
        {
            colors = {
                up_to_date = "#3C4048", -- Text color for up to date package virtual text
                outdated = "#d19a66" -- Text color for outdated package virtual text
            },
            icons = {
                enable = true, -- Whether to display icons
                style = {
                    up_to_date = "|  ", -- Icon for up to date packages
                    outdated = "|  " -- Icon for outdated packages
                }
            },
            autostart = true, -- Whether to autostart when `package.json` is opened
            hide_up_to_date = true, -- It hides up to date versions when displaying virtual text
            hide_unstable_versions = false, -- It hides unstable versions from version list e.g next-11.1.3-canary3
            -- `npm`, `yarn`
            package_manager = "yarn"
        }
    )

    command(
        "PackageInfo",
        function()
            require("package-info").show()
        end
    )
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                       open-browser                       │
-- ╰──────────────────────────────────────────────────────────╯
function M.open_browser()
    wk.register(
        {
            -- ["gX"] = {":lua R('functions').go_github()<CR>", "Open link under cursor"},
            ["gX"] = {"<Plug>(openbrowser-open)", "Open link under cursor"},
            ["gx"] = {":lua R('functions').open_link()<CR>", "Open link or file under cursor"},
            ["gf"] = {":lua R('functions').open_path()<CR>", "Open path under cursor"},
            ["<LocalLeader>?"] = {"<Plug>(openbrowser-search)", "Search under cursor"}
        }
    )

    wk.register(
        {
            ["<LocalLeader>?"] = {"<Plug>(openbrowser-search)", "Search under cursor"}
        },
        {mode = "x"}
    )
end

-- /home/lucas/.config/zsh
-- /home/lucas/.config/zsh/.zshrc
-- https://github.com/lmburns/dotfiles

-- ╭──────────────────────────────────────────────────────────╮
-- │                           Suda                           │
-- ╰──────────────────────────────────────────────────────────╯
function M.suda()
    map("n", "<Leader>W", ":SudaWrite<CR>")
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                          GHLine                          │
-- ╰──────────────────────────────────────────────────────────╯
function M.ghline()
    -- map("n", "<Leader>go", ":<C-u>CocCommand git.browserOpen<CR>", {silent = true})

    wk.register(
        {
            ["<Leader>go"] = {"<Plug>(gh-repo)", "Open git repo"},
            ["<Leader>gL"] = {"<Plug>(gh-line)", "Open git line"}
        }
    )
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                       Persistence                        │
-- ╰──────────────────────────────────────────────────────────╯
function M.persistence()
    require("persistence").setup(
        {
            dir = ("%s/%s"):format(fn.stdpath("data"), "/sessions/"),
            options = {"buffers", "curdir", "tabpages", "winsize"}
        }
    )
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                         Floaterm                         │
-- ╰──────────────────────────────────────────────────────────╯
function M.floaterm()
    map("n", "<Leader>fll", ":Floaterms<CR>")
    map("n", ";fl", ":FloatermToggle<CR>")

    g.fzf_floaterm_newentries = {
        ["+lazygit"] = {
            title = "lazygit",
            height = 0.9,
            width = 0.9,
            cmd = "lazygit"
        },
        ["+gitui"] = {title = "gitui", height = 0.9, width = 0.9, cmd = "gitui"},
        ["+taskwarrior-tui"] = {
            title = "taskwarrior-tui",
            height = 0.99,
            width = 0.99,
            cmd = "taskwarrior-tui"
        },
        ["+flf"] = {
            title = "full screen lf",
            height = 0.9,
            width = 0.9,
            cmd = "lf"
        },
        ["+slf"] = {
            title = "split screen lf",
            wintype = "split",
            height = 0.5,
            cmd = "lf"
        },
        ["+xplr"] = {title = "xplr", cmd = "xplr"},
        ["+gpg-tui"] = {
            title = "gpg-tui",
            height = 0.9,
            width = 0.9,
            cmd = "gpg-tui"
        },
        ["+tokei"] = {title = "tokei", height = 0.9, width = 0.9, cmd = "tokei"},
        ["+dust"] = {title = "dust", height = 0.9, width = 0.9, cmd = "dust"},
        ["+zsh"] = {title = "zsh", height = 0.9, width = 0.9, cmd = "zsh"}
    }

    g.floaterm_shell = "zsh"
    g.floaterm_wintype = "float"
    g.floaterm_height = 0.85
    g.floaterm_width = 0.9
    g.floaterm_borderchars = "─│─│╭╮╯╰"

    C.plugin(
        "floaterm",
        {
            FloatermBorder = {fg = "#A06469", gui = "none"}
        }
    )

    -- Stackoverflow helper
    map("n", "<Leader>so", ":FloatermNew --autoclose=0 so<space>")
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                          Pandoc                          │
-- ╰──────────────────────────────────────────────────────────╯
-- function M.pandoc()
--     g["pandoc#filetypes#handled"] = {"pandoc", "markdown"}
--     g["pandoc#after#modules#enabled"] = {"vim-table-mode"}
--     g["pandoc#syntax#codeblocks#embeds#langs"] = {
--         "c",
--         "python",
--         "sh",
--         "html",
--         "css"
--     }
--     g["pandoc#formatting#mode"] = "h"
--     g["pandoc#modules#disabled"] = {"folding", "formatting"}
--     g["pandoc#syntax#conceal#cchar_overrides"] = {codelang = " "}
-- end

-- ╭──────────────────────────────────────────────────────────╮
-- │                         Markdown                         │
-- ╰──────────────────────────────────────────────────────────╯
function M.markdown()
    g.markdown_fenced_languages = {
        "vim",
        "html",
        "c",
        "py=python",
        "python",
        "go",
        "rust",
        "rs=rust",
        "sh",
        "shell=sh",
        "bash=sh",
        "json",
        "yaml",
        "toml",
        "help"
    }
    -- use `ge`
    g.vim_markdown_follow_anchor = 1
    -- g.vim_markdown_folding_disabled = 1

    g.vim_markdown_conceal = 0
    g.vim_markdown_conceal_code_blocks = 0
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                        TableMode                         │
-- ╰──────────────────────────────────────────────────────────╯
function M.table_mode()
    augroup(
        "TableMode",
        {
            event = "FileType",
            pattern = {"markdown", "vimwiki"},
            command = function()
                g.table_mode_map_prefix = "<Leader>t"
                g.table_mode_realign_map = "<Leader>tr"
                g.table_mode_delete_row_map = "<Leader>tdd"
                g.table_mode_delete_column_map = "<Leader>tdc"
                g.table_mode_insert_column_after_map = "<Leader>tic"
                g.table_mode_echo_cell_map = "<Leader>t?"
                g.table_mode_sort_map = "<Leader>ts"
                g.table_mode_tableize_map = "<Leader>tt"
                g.table_mode_tableize_d_map = "<Leader>T"
                g.table_mode_tableize_auto_border = 1
                g.table_mode_corner = "|"
                g.table_mode_fillchar = "-"
                g.table_mode_separator = "|"

                -- Expand snippets in VimWiki
                map("i", "<right>", [[pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"]], {expr = true})
            end
        }
    )
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                         VimWiki                          │
-- ╰──────────────────────────────────────────────────────────╯
function M.vimwiki()
    -- g.vimwiki_ext2syntax = {
    --   [".Rmd"] = "markdown",
    --   [".rmd"] = "markdown",
    --   [".md"] = "markdown",
    --   [".markdown"] = "markdown",
    --   [".mdown"] = "markdown",
    -- }
    -- g.vimwiki_list = { { path = "~/vimwiki", syntax = "markdown", ext = ".md" } }
    -- g.vimwiki_table_mappings = 0

    C.all(
        {
            VimwikiBold = {fg = "#a25bc4", bold = true},
            VimwikiCode = {fg = "#d3869b"},
            VimwikiItalic = {fg = "#83a598", italic = true},
            VimwikiHeader1 = {fg = "#F14A68", bold = true},
            VimwikiHeader2 = {fg = "#F06431", bold = true},
            VimwikiHeader3 = {fg = "#689d6a", bold = true},
            VimwikiHeader4 = {fg = "#819C3B", bold = true},
            VimwikiHeader5 = {fg = "#98676A", bold = true},
            VimwikiHeader6 = {fg = "#458588", bold = true}
        }
    )

    -- highlight TabLineSel guifg=#37662b guibg=NONE

    map("n", "<Leader>vw", ":VimwikiIndex<CR>")
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                        UltiSnips                         │
-- ╰──────────────────────────────────────────────────────────╯
function M.ultisnips()
    -- This works on snippets like #! where a popup menu doesn't appear
    -- g.UltiSnipsExpandTrigger = "<Leader><tab>"
    g.UltiSnipsExpandTrigger = "<Nop>"

    -- g.UltiSnipsJumpForwardTrigger = "<C-j>"
    -- g.UltiSnipsJumpBackwardTrigger = "<C-k>"
    -- g.UltiSnipsListSnippets = "<C-u>"
    g.UltiSnipsEditSplit = "horizontal"
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                           Info                           │
-- ╰──────────────────────────────────────────────────────────╯
function M.info()
    -- Anonymous
    nvim.create_autocmd(
        "BufEnter",
        {
            pattern = "*",
            callback = function()
                local bufnr = nvim.get_current_buf()
                if b[bufnr].ft == "info" then
                    map("n", "gu", "<Plug>(InfoUp)", {buffer = bufnr})
                    map("n", "gn", "<Plug>(InfoNext)", {buffer = bufnr})
                    map("n", "gp", "<Plug>(InfoPrev)", {buffer = bufnr})
                    map("n", "gm", "<Plug>(InfoMenu)", {buffer = bufnr})
                    map("n", "gf", "<Plug>(InfoFollow)", {buffer = bufnr})
                end
            end
        }
    )
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                          Slime                           │
-- ╰──────────────────────────────────────────────────────────╯
function M.slime()
    g.slime_target = "neovim"
    g.syntastic_python_pylint_post_args = "--max-line-length=120"

    cmd [[
    if !empty(glob('$XDG_DATA_HOME/pyenv/shims/python3'))
      let g:python3_host_prog = glob('$XDG_DATA_HOME/pyenv/shims/python')
    endif

    augroup repl
      autocmd!
      autocmd FileType python
        \ xmap <buffer> ,l <Plug>SlimeRegionSend|
        \ nmap <buffer> ,l <Plug>SlimeLineSend|
        \ nmap <buffer> ,p <Plug>SlimeParagraphSend|
        \ nnoremap <silent> <S-CR> :TREPLSendLine<CR><Esc><Home><Down>|
        \ inoremap <silent> <S-CR> <Esc>:TREPLSendLine<CR><Esc>A|
        \ xnoremap <silent> <S-CR> :TREPLSendSelection<CR><Esc><Esc>
        \ nnoremap <Leader>rF :T ptpython<CR>|
        \ nnoremap <Leader>rf :T ipython --no-autoindent --colors=Linux --matplotlib<CR>|
        \ nmap <buffer> <Leader>r<CR> :VT python %<CR>|
        \ nnoremap ,rp :SlimeSend1 <C-r><C-w><CR>|
        \ nnoremap ,rP :SlimeSend1 print(<C-r><C-w>)<CR>|
        \ nnoremap ,rs :SlimeSend1 print(len(<C-r><C-w>), type(<C-r><C-w>))<CR>|
        \ nnoremap ,rt :SlimeSend1 <C-r><C-w>.dtype<CR>|
        \ nnoremap 223 ::%s/^\(\s*print\)\s\+\(.*\)/\1(\2)<CR>|
        \ nnoremap ,rr :FloatermNew --autoclose=0 python %<space>

      autocmd FileType perl nmap <buffer> ,l <Plug>SlimeLineSend
    augroup END
  ]]
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                          Notify                          │
-- ╰──────────────────────────────────────────────────────────╯
function M.notify()
    -- if g.packer_compiled_loaded then
    --     return
    -- end

    --   cmd [[
    --   hi NotifyERRORBorder guifg=#8A1F1F
    --   hi NotifyWARNBorder guifg=#79491D
    --   hi NotifyINFOBorder guifg=#4F6752
    --   hi NotifyDEBUGBorder guifg=#8B8B8B
    --   hi NotifyTRACEBorder guifg=#4F3552
    --   hi NotifyERRORIcon guifg=#F70067
    --   hi NotifyWARNIcon guifg=#fe8019
    --   hi NotifyINFOIcon guifg=#a3b95a
    --   hi NotifyDEBUGIcon guifg=#8B8B8B
    --   hi NotifyTRACEIcon guifg=#D484FF
    --   hi NotifyERRORTitle  guifg=#F70067
    --   hi NotifyWARNTitle guifg=#fe8019
    --   hi NotifyINFOTitle guifg=#a3b95a
    --   hi NotifyDEBUGTitle  guifg=#8B8B8B
    --   hi NotifyTRACETitle  guifg=#D484FF
    --   hi link NotifyERRORBody Normal
    --   hi link NotifyWARNBody Normal
    --   hi link NotifyINFOBody Normal
    --   hi link NotifyDEBUGBody Normal
    --   hi link NotifyTRACEBody Normal
    -- ]]

    C.plugin(
        "notify",
        {
            NotifyERRORBorder = {bg = {from = "NormalFloat"}},
            NotifyWARNBorder = {bg = {from = "NormalFloat"}},
            NotifyINFOBorder = {bg = {from = "NormalFloat"}},
            NotifyDEBUGBorder = {bg = {from = "NormalFloat"}},
            NotifyTRACEBorder = {bg = {from = "NormalFloat"}},
            NotifyERRORBody = {link = "NormalFloat"},
            NotifyWARNBody = {link = "NormalFloat"},
            NotifyINFOBody = {link = "NormalFloat"},
            NotifyDEBUGBody = {link = "NormalFloat"},
            NotifyTRACEBody = {link = "NormalFloat"}
        }
    )

    ---@type table<string, fun(bufnr: number, notif: table, highlights: table)>
    local renderer = require("notify.render")
    local notify = require("notify")

    notify.setup(
        {
            stages = "fade_in_slide_out",
            -- stages = "slide",
            timeout = 3000,
            minimum_width = 30,
            background_color = "NormalFloat",
            -- on_close = function()
            -- -- Could create something to write to a file
            -- end,
            -- on_open = function(win)
            --     if nvim.win.is_valid(win) then
            --     end
            -- end,
            render = function(bufnr, notif, highlights)
                local style = notif.title[1] == "" and "minimal" or "default"
                renderer[style](bufnr, notif, highlights)
            end,
            icons = {
                ERROR = " ",
                WARN = " ",
                INFO = " ",
                DEBUG = " ",
                TRACE = " "
            }
        }
    )

    wk.register(
        {
            ["<Leader>nd"] = {notify.dismiss, "Dismiss notification"}
        }
    )

    require("telescope").load_extension("notify")
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                          Neogen                          │
-- ╰──────────────────────────────────────────────────────────╯
function M.neogen()
    local neogen = require("neogen")
    neogen.setup(
        {
            enabled = true,
            input_after_comment = true,
            languages = {lua = {template = {annotation_convention = "emmylua"}}}
        }
    )
    map("i", "<C-.>", [[<Cmd>lua require('neogen').jump_next()<CR>]])
    map("i", "<C-,>", [[<Cmd>lua require('neogen').jump_prev()<CR>]])
    map("n", "<Leader>dg", [[:Neogen<Space>]])
    map("n", "<Leader>df", [[<Cmd>lua require('neogen').generate({ type = 'func' })<CR>]])
    map("n", "<Leader>dc", [[<cmd>lua require("neogen").generate({ type = "class" })<CR>]])
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                         VCooler                          │
-- ╰──────────────────────────────────────────────────────────╯
function M.vcoolor()
    map("n", "<Leader>pc", ":VCoolor<CR>")
    map("n", "<Leader>yb", ":VCoolIns b<CR>")
    map("n", "<Leader>yr", ":VCoolIns r<CR>")
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                         HlsLens                          │
-- ╰──────────────────────────────────────────────────────────╯
function M.hlslens()
    require("hlslens").setup(
        {
            auto_enable = true,
            enable_incsearch = true,
            calm_down = false,
            nearest_only = false,
            nearest_float_when = "auto",
            float_shadow_blend = 50,
            virt_priority = 100,
            build_position_cb = function(plist, _, _, _)
                require("scrollbar.handlers.search").handler.show(plist.start_pos)
            end
        }
    )

    command(
        "HlSearchLensToggle",
        function()
            require("hlslens").toggle()
        end
    )

    map(
        "n",
        "n",
        [[<Cmd>execute('norm! ' . v:count1 . 'nzv')<CR>]] ..
            [[<Cmd>lua require('hlslens').start()<CR>]] .. [[<Cmd>lua require("specs").show_specs()<CR>]]
    )
    map(
        "n",
        "N",
        [[<Cmd>execute('norm! ' . v:count1 . 'Nzv')<CR>]] ..
            [[<Cmd>lua require('hlslens').start()<CR>]] .. [[<Cmd>lua require("specs").show_specs()<CR>]]
    )
    map("n", "*", [[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]], {noremap = false})
    map("n", "#", [[<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>]], {})
    map("n", "g*", [[<Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>]], {noremap = false})
    map("n", "g#", [[<Plug>(asterisk-gz#)<Cmd>lua require('hlslens').start()<CR>]], {noremap = false})

    map("x", "*", [[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]], {noremap = false})
    map("x", "#", [[<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>]], {noremap = false})
    map("x", "g*", [[<Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>]], {})
    map("x", "g#", [[<Plug>(asterisk-gz#)<Cmd>lua require('hlslens').start()<CR>]], {})

    g["asterisk#keeppos"] = 1
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                         Surround                         │
-- ╰──────────────────────────────────────────────────────────╯
-- function M.surround()
--     map("n", "ds", "<Plug>Dsurround")
--     map("n", "cs", "<Plug>Csurround")
--     map("n", "cS", "<Plug>CSurround")
--     map("n", "ys", "<Plug>Ysurround")
--     map("n", "yS", "<Plug>YSurround")
--     map("n", "yss", "<Plug>Yssurround")
--     map("n", "ygs", "<Plug>YSsurround")
--     map("x", "S", "<Plug>VSurround")
--     map("x", "gS", "<Plug>VgSurround")
-- end

-- ╭──────────────────────────────────────────────────────────╮
-- │                        Sandwhich                         │
-- ╰──────────────────────────────────────────────────────────╯
function M.sandwhich()
    -- Sandwhich
    -- dss = automatic deletion
    -- css = automatic changing
    -- ySi = ask head and tail (Add)
    -- yS = to end of line
    -- yss = whole line
    -- yiss = inside nearest delimiter
    -- y{a,i}si = head - tail (select)
    -- yaa = <here>
    -- yar = [here]
    -- ygs = (\n<line>\n)
    -- ds<CR> = delete line above/below

    -- === Visual ===
    -- Si = head - tail
    -- gS = (\n<line>\n)

    -- --Old--                   ---Input---        ---Output---
    -- "hello"                   ysiwtkey<cr>       "<key>hello</key>"
    -- "hello"                   ysiwP<cr>          |("hello")
    -- "hello"                   ysiwfprint<cr>     print("hello")
    -- print("hello")            dsf                "hello"

    -- TODO: These
    -- "hello"                   ysWFprint<cr>     print( "hello" )
    -- "hello"                   ysW<C-f>print<cr> (print "hello")

    -- This allows for macros in Rust
    vim.g["sandwich#magicchar#f#patterns"] = {
        {
            header = [[\<\h\k*]],
            bra = "(",
            ket = ")",
            footer = ""
        },
        {
            header = [[\<\h\k*!]],
            bra = "(",
            ket = ")",
            footer = ""
        }
    }

    ex.runtime("macros/sandwich/keymap/surround.vim")

    cmd [[
      let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)

      let g:sandwich#recipes += [
      \   {
      \     'buns': ['{ ', ' }'],
      \     'nesting': 1,
      \     'match_syntax': 1,
      \     'kind': ['add', 'replace'],
      \     'action': ['add'],
      \     'input': ['{']
      \   },
      \   {
      \     'buns': ['[ ', ' ]'],
      \     'nesting': 1,
      \     'match_syntax': 1,
      \     'kind': ['add', 'replace'],
      \     'action': ['add'],
      \     'input': ['[']
      \   },
      \   {
      \     'buns': ['( ', ' )'],
      \     'nesting': 1,
      \     'match_syntax': 1,
      \     'kind': ['add', 'replace'],
      \     'action': ['add'],
      \     'input': ['(']
      \   },
      \   {
      \     'buns': ['{\s*', '\s*}'],
      \     'nesting': 1,
      \     'regex': 1,
      \     'match_syntax': 1,
      \     'kind': ['delete', 'replace', 'textobj'],
      \     'action': ['delete'],
      \     'input': ['{']
      \   },
      \   {
      \     'buns': ['\[\s*', '\s*\]'],
      \     'nesting': 1,
      \     'regex': 1,
      \     'match_syntax': 1,
      \     'kind': ['delete', 'replace', 'textobj'],
      \     'action': ['delete'],
      \     'input': ['[']
      \   },
      \   {
      \     'buns': ['(\s*', '\s*)'],
      \     'nesting': 1,
      \     'regex': 1,
      \     'match_syntax': 1,
      \     'kind': ['delete',
      \     'replace', 'textobj'],
      \     'action': ['delete'],
      \     'input': ['(']
      \   },
      \   {
      \     'buns'        : ['{', '}'],
      \     'motionwise'  : ['line'],
      \     'kind'        : ['add'],
      \     'linewise'    : 1,
      \     'command'     : ["'[+1,']-1normal! >>"],
      \   },
      \   {
      \     'buns'        : ['{', '}'],
      \     'motionwise'  : ['line'],
      \     'kind'        : ['delete'],
      \     'linewise'    : 1,
      \     'command'     : ["'[,']normal! <<"],
      \   },
      \   {
      \     'buns': ['(', ')'],
      \     'cursor': 'head',
      \     'command': ['startinsert'],
      \     'kind': ['add', 'replace'],
      \     'action': ['add'],
      \     'input': ['P']
      \   },
      \   {
      \     'buns': ['\s\+', '\s\+'],
      \     'regex': 1,
      \     'kind': ['delete', 'replace', 'query'],
      \     'input': [' ']
      \   },
      \   {
      \     'buns':         ['', ''],
      \     'action':       ['add'],
      \     'motionwise':   ['line'],
      \     'linewise':     1,
      \     'input':        ["\<CR>"]
      \   },
      \   {
      \     'buns':         ['^$', '^$'],
      \     'regex':        1,
      \     'linewise':     1,
      \     'input':        ["\<CR>"]
      \   },
      \   {
      \     'buns':         ['{', '}'],
      \     'nesting':      1,
      \     'skip_break':   1,
      \     'input':        ['{', '}', 'B'],
      \   },
      \   {
      \     'buns':         ['[', ']'],
      \     'nesting':      1,
      \     'input':        ['[', ']', 'r'],
      \   },
      \   {
      \     'buns':         ['(', ')'],
      \     'nesting':      1,
      \     'input':        ['(', ')', 'b'],
      \   },
      \   {
      \     'buns':         ['<', '>'],
      \     'expand_range': 0,
      \     'input':        ['>', 'a'],
      \   },
      \ ]
    ]]

    -- TODO
    -- \   {
    -- \     'buns': ['sandwich#magicchar#f#fname()' . '\<Space>', '" )"'],
    -- \     'kind': ['add'],
    -- \     'action': ['add'],
    -- \     'expr': 1,
    -- \     'input': ['J']
    -- \   },
    -- \   {
    -- \     'buns'        : ["'", "'"],
    -- \     'motionwise'  : ['line'],
    -- \     'kind'        : ['add'],
    -- \     'linewise'    : 1,
    -- \     'command'     : ["'[+1,']-1normal! >>"],
    -- \   },

    map({"x", "o"}, "is", "<Plug>(textobj-sandwich-query-i)")
    map({"x", "o"}, "as", "<Plug>(textobj-sandwich-query-a)")
    map({"x", "o"}, "iss", "<Plug>(textobj-sandwich-auto-i)")
    map({"x", "o"}, "ass", "<Plug>(textobj-sandwich-auto-a)")
    -- map({"x", "o"}, "im", "<Plug>(textobj-sandwich-literal-query-i)")
    -- map({"x", "o"}, "am", "<Plug>(textobj-sandwich-literal-query-a)")
    map("n", "ygs", "<Plug>(sandwich-add):normal! V<CR>")
    map("x", "gS", ":<C-u>normal! V<CR><Plug>(sandwich-add)")

    wk.register(
        {
            ["<Leader>o"] = {"<Plug>(sandwich-add)iw", "Surround a word"}
        }
    )

    -- map("n", "mlw", "yss`", {noremap = false})
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                         targets                          │
-- ╰──────────────────────────────────────────────────────────╯
-- http://vimdoc.sourceforge.net/htmldoc/motion.html#operator
function M.targets()
    -- Cheatsheet: https://github.com/wellle/targets.vim/blob/master/cheatsheet.md
    -- vI) = contents inside pair
    -- in( an( In( An( il( al( Il( Al( ... next and last pair
    -- {a,I,A}{,.;+=...} = a/inside/around separator
    -- inb anb Inb Anb ilb alb Ilb Alb = any block
    -- inq anq Inq Anq ilq alq Ilq Alq == any quote

    -- cib = change in () or {}

    augroup(
        "lmb__Targets",
        {
            event = "User",
            pattern = "targets#mappings#user",
            command = function()
                fn["targets#mappings#extend"](
                    {
                        -- Parameter
                        -- a = {argument = {{o = "(", c = ")", s = ","}}},
                        a = {pair = {{o = "<", c = ">"}}},
                        r = {pair = {{o = "[", c = "]"}}},
                        -- Closest separator
                        -- g = {
                        --     separator = {
                        --         {d = ","},
                        --         {d = "."},
                        --         {d = ";"},
                        --         {d = "="},
                        --         {d = "+"},
                        --         {d = "-"},
                        --         {d = "="},
                        --         {d = "~"},
                        --         {d = "_"},
                        --         {d = "*"},
                        --         {d = "#"},
                        --         {d = "/"},
                        --         {d = [[\]]},
                        --         {d = "|"},
                        --         {d = "&"},
                        --         {d = "$"}
                        --     }
                        -- },
                        -- Closest text object
                        ["@"] = {
                            separator = {
                                {d = ","},
                                {d = "."},
                                {d = ";"},
                                {d = "="},
                                {d = "+"},
                                {d = "-"},
                                {d = "="},
                                {d = "~"},
                                {d = "_"},
                                {d = "*"},
                                {d = "#"},
                                {d = "/"},
                                {d = [[\]]},
                                {d = "|"},
                                {d = "&"},
                                {d = "$"}
                            },
                            pair = {{o = "(", c = ")"}, {o = "[", c = "]"}, {o = "{", c = "}"}, {o = "<", c = ">"}},
                            quote = {{d = "'"}, {d = '"'}, {d = "`"}},
                            tag = {{}}
                        }
                    }
                )
            end
        }
    )

    wk.register(
        {
            ["ir"] = "Inner brace",
            ["ar"] = "Around brace",
            ["ia"] = "Inner angle bracket",
            ["aa"] = "Around angle bracket",
            ["in"] = "Next object",
            ["im"] = "Previous object",
            ["an"] = "Next object",
            ["am"] = "Previous object"
        },
        {mode = "o"}
    )

    -- c: on cursor position
    -- l: left of cursor in current line
    -- r: right of cursor in current line
    -- a: above cursor on screen
    -- b: below cursor on screen
    -- A: above cursor off screen
    -- B: below cursor off screen
    g.targets_seekRanges = "cc cr cb cB lc ac Ac lr lb ar ab lB Ar aB Ab AB rr ll rb al rB Al bb aa bB Aa BB AA"
    -- g.targets_jumpRanges = g.targets_seekRanges
    -- g.targets_aiAI = "aIAi"
    --
    -- -- Seeking next/last objects
    -- g.targets_nl = "nN"
    g.targets_nl = "nm"

    -- map("o", "I", [[targets#e('o', 'i', 'I')]], { expr = true })
    -- map("x", "I", [[targets#e('o', 'i', 'I')]], { expr = true })
    -- map("o", "a", [[targets#e('o', 'a', 'a')]], { expr = true })
    -- map("x", "a", [[targets#e('o', 'a', 'a')]], { expr = true })
    -- map("o", "i", [[targets#e('o', 'I', 'i')]], { expr = true })
    -- map("x", "i", [[targets#e('o', 'I', 'i')]], { expr = true })
    -- map("o", "A", [[targets#e('o', 'A', 'A')]], { expr = true })
    -- map("x", "A", [[targets#e('o', 'A', 'A')]], { expr = true })
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                         MatchUp                          │
-- ╰──────────────────────────────────────────────────────────╯
function M.matchup()
    -- hi MatchParenCur cterm=underline gui=underline
    -- hi MatchWordCur cterm=underline gui=underline

    g.loaded_matchit = 1
    g.matchup_enabled = 1
    g.matchup_motion_enabled = 1
    g.matchup_text_obj_enabled = 1
    g.matchup_matchparen_enabled = 1
    g.matchup_surround_enabled = 0
    -- g.matchup_transmute_enabled = 0
    -- g.matchup_matchparen_offscreen = {method = "status_manual"}
    g.matchup_matchparen_offscreen = {method = "popup"}

    -- g.matchup_text_obj_linewise_operators = {"d", "y"}
    -- g.matchup_matchparen_deferred = 1
    -- g.matchup_matchparen_deferred_show_delay = 100
    -- g.matchup_matchparen_hi_surround_always = 1
    -- g.matchup_override_vimtex = 1
    -- g.matchup_delim_start_plaintext = 0
    map("o", "%", "]%")
    -- map("o", "%", "<Plug>(matchup-%)")
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                       BetterEscape                       │
-- ╰──────────────────────────────────────────────────────────╯
function M.better_esc()
    require("better_escape").setup {
        mapping = {"jk", "kj"}, -- a table with mappings to use
        timeout = vim.o.timeoutlen, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
        clear_empty_lines = false, -- clear line after escaping if there is only whitespace
        keys = "<Esc>" -- keys used for escaping, if it is a function will use the result everytime
        -- keys = function()
        --   return api.nvim_win_get_cursor(0)[2] > 1 and "<esc>l" or "<esc>"
        -- end,
    }
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                       SmartSplits                        │
-- ╰──────────────────────────────────────────────────────────╯
function M.smartsplits()
    require("smart-splits").setup(
        {
            -- Ignored filetypes (only while resizing)
            ignored_filetypes = {"nofile", "quickfix", "prompt"},
            -- Ignored buffer types (only while resizing)
            ignored_buftypes = {"NvimTree"},
            -- when moving cursor between splits left or right,
            -- place the cursor on the same row of the *screen*
            -- regardless of line numbers. False by default.
            -- Can be overridden via function parameter, see Usage.
            move_cursor_same_row = false
        }
    )

    -- Can be achieved with custom function, but this has more functionality

    -- map("n", "<C-Up>", [[:lua require('common.utils').resize(false, -1)<CR>]])
    -- map("n", "<C-Down>", [[:lua require('common.utils').resize(false, 1)<CR>]])
    -- map("n", "<C-Right>", [[:lua require('common.utils').resize(true, 1)<CR>]])
    -- map("n", "<C-Left>", [[:lua require('common.utils').resize(true, -1)<CR>]])

    local ss = require("smart-splits")

    -- Move between windows
    wk.register(
        {
            ["<C-j>"] = {ss.move_cursor_down, "Move to below window"},
            ["<C-k>"] = {ss.move_cursor_up, "Move to above window"},
            ["<C-h>"] = {ss.move_cursor_left, "Move to left window"},
            ["<C-l>"] = {ss.move_cursor_right, "Move to right window"},
            ["<C-Up>"] = {ss.resize_up, "Resize window up"},
            ["<C-Down>"] = {ss.resize_down, "Resize window down"},
            ["<C-Right>"] = {ss.resize_right, "Resize window right"},
            ["<C-Left>"] = {ss.resize_left, "Resize window left"}
        }
    )
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                           Move                           │
-- ╰──────────────────────────────────────────────────────────╯
function M.move()
    -- Move selected text up down
    -- map("v", "J", ":m '>+1<CR>gv=gv")
    -- map("v", "K", ":m '<-2<CR>gv=gv")
    -- map("i", "<C-J>", "<C-o><Cmd>m +1<CR>")
    -- map("i", "<C-K>", "<C-o><Cmd>m -2<CR>")
    -- map("n", "<C-,>", "<Cmd>m +1<CR>")
    -- map("n", "<C-.>", "<Cmd>m -2<CR>")

    wk.register(
        {
            ["J"] = {":MoveBlock(1)<CR>", "Move selected text down"},
            ["K"] = {":MoveBlock(-1)<CR>", "Move selected text up"}
        },
        {mode = "v"}
    )

    wk.register(
        {
            ["<C-j>"] = {"<C-o><Cmd>MoveLine(1)<CR>", "Move line down"},
            ["<C-k>"] = {"<C-o><Cmd>MoveLine(-1)<CR>", "Move line up"}
        },
        {mode = "i"}
    )

    -- https://www.reddit.com/r/neovim/comments/mbj8m5/how_to_setup_ctrlshiftkey_mappings_in_neovim_and/
    -- https://www.eso.org/~ndelmott/ascii.html
    wk.register(
        {
            ["<C-S-l>"] = {":MoveHChar(1)<CR>", "Move character one left"},
            ["<C-S-h>"] = {":MoveHChar(-1)<CR>", "Move character one right"},
            ["<C-S-j>"] = {":MoveLine(1)<CR>", "Move line down"},
            ["<C-S-k>"] = {":MoveLine(-1)<CR>", "Move line up"}
        },
        {mode = "n"}
    )
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                      Window Picker                       │
-- ╰──────────────────────────────────────────────────────────╯
function M.window_picker()
    require("nvim-window").setup(
        {
            -- The characters available for hinting windows.
            chars = {
                "a",
                "s",
                "d",
                "f",
                "q",
                "w",
                "e",
                "r",
                "t",
                "z",
                "g",
                ";",
                ","
            },
            -- A group to use for overwriting the Normal highlight group in the floating
            -- window. This can be used to change the background color.
            normal_hl = "Normal",
            -- The highlight group to apply to the line that contains the hint characters.
            -- This is used to make them stand out more.
            hint_hl = "Bold",
            -- The border style to use for the floating window.
            border = "single"
        }
    )

    map("n", "<M-->", "<cmd>lua require('nvim-window').pick()<CR>")
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                         LazyGit                          │
-- ╰──────────────────────────────────────────────────────────╯
function M.lazygit()
    g.lazygit_floating_window_winblend = 0 -- transparency of floating window
    g.lazygit_floating_window_scaling_factor = 0.9 -- scaling factor for floating window
    g.lazygit_floating_window_corner_chars = {"╭", "╮", "╰", "╯"} -- customize lazygit popup window corner characters
    g.lazygit_floating_window_use_plenary = 1 -- use plenary.nvim to manage floating window if available
    g.lazygit_use_neovim_remote = 1 -- fallback to 0 if neovim-remote is not installed

    -- autocmd(
    --     {
    --         event = "BufEnter",
    --         pattern = "*",
    --         command = function()
    --             require("lazygit.utils").project_root_dir()
    --         end
    --     }
    -- )

    require("telescope").load_extension("lazygit")
    map("n", "<Leader>lg", ":LazyGit<CR>", {silent = true})
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                          Specs                           │
-- ╰──────────────────────────────────────────────────────────╯
function M.specs()
    require("specs").setup(
        {
            show_jumps = true,
            min_jump = fn.winheight("%"),
            popup = {
                delay_ms = 0, -- delay before popup displays
                inc_ms = 20, -- time increments used for fade/resize effects
                blend = 20, -- starting blend, between 0-100 (fully transparent), see :h winblend
                width = 20,
                winhl = "PMenu",
                fader = require("specs").linear_fader,
                resizer = require("specs").shrink_resizer
            },
            ignore_filetypes = {["TelescopePrompt"] = true},
            ignore_buftypes = {nofile = true}
        }
    )
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

    map("n", "<Leader>sc", "<cmd>lua R'scratchpad'.invoke()<CR>")
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                           NLua                           │
-- ╰──────────────────────────────────────────────────────────╯
--- This involves the original mapping in `nlua` to be commented out
function M.nlua()
    map("n", "M", [[<cmd>lua require("nlua").keyword_program()<CR>]])
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
    require("paperplanes").setup(
        {
            register = "+",
            provider = "0x0.st",
            provider_options = {},
            cmd = "curl"
        }
    )
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                        Colorizer                         │
-- ╰──────────────────────────────────────────────────────────╯
function M.colorizer()
    require("colorizer").setup(
        {
            "gitconfig",
            "vim",
            "sh",
            "zsh",
            "markdown",
            "tmux",
            "yaml",
            "json",
            "xml",
            "css",
            "typescript",
            "javascript",
            lua = {names = false}
        },
        {
            RGB = true,
            RRGGBB = true,
            RRGGBBAA = true,
            names = false,
            mode = "background"
        }
    )
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                         Grepper                          │
-- ╰──────────────────────────────────────────────────────────╯
function M.grepper()
    -- TODO: Figure out a way to change dir for GrepperOperator
    g.grepper = {
        dir = "repo,file",
        simple_prompt = 1,
        searchreg = 1,
        stop = 50000,
        tools = {"rg", "git"},
        rg = {
            grepprg = "rg -H --no-heading --max-columns=200 --vimgrep --smart-case --color=never",
            grepformat = "%f:%l:%c:%m,%f:%l:%m"
        }
    }

    -- $. = current file
    -- $+ = currently opened files
    map("n", "gs", "<Plug>(GrepperOperator)")
    map("x", "gs", "<Plug>(GrepperOperator)")
    map("n", "<Leader>rg", [[<Cmd>Grepper<CR>]])

    augroup(
        "Grepper",
        {
            event = "User",
            pattern = "Grepper",
            nested = true,
            command = function()
                -- \%# = cursor position
                fn.setqflist({}, "r", {context = {bqf = {pattern_hl = [[\%#]] .. nvim.reg["/"]}}})
            end
        }
    )
end

-- ╓                                                          ╖
-- ║                        CommentBox                        ║
-- ╙                                                          ╜
function M.comment_box()
    local cb = require("comment-box")
    cb.setup(
        {
            doc_width = 80, -- width of the document
            box_width = 60, -- width of the boxes
            borders = {
                -- symbols used to draw a box
                top = "─",
                bottom = "─",
                left = "│",
                right = "│",
                top_left = "╭",
                top_right = "╮",
                bottom_left = "╰",
                bottom_right = "╯"
            },
            line_width = 70, -- width of the lines
            line = {
                -- symbols used to draw a line
                line = "─",
                line_start = "─",
                line_end = "─"
            },
            outer_blank_lines = false, -- insert a blank line above and below the box
            inner_blank_lines = false, -- insert a blank line above and below the text
            line_blank_line_above = false, -- insert a blank line above the line
            line_blank_line_below = false -- insert a blank line below the line
        }
    )

    --        Box | Size | Text
    -- lbox    L     F      L
    -- clbox   C     F      L
    -- cbox    L     F      C
    -- ccbox   C     F      C
    -- albox   L     A      L
    -- aclbox  C     A      L
    -- acbox   L     A      C
    -- accbox  C     A      C

    -- 21 20 19 18 7
    map({"n", "v"}, "<Leader>bb", cb.cbox, {desc = "Left fixed box, center text (round)"})

    map(
        {"n", "v"},
        "<Leader>bh",
        function()
            cb.cbox(19)
        end,
        {desc = "Left fixed box, center text (sides)"}
    )
    map(
        {"n", "v"},
        "<Leader>cc",
        function()
            cb.cbox(21)
        end,
        {desc = "Left fixed box, center text (top)"}
    )
    map(
        {"n", "v"},
        "<Leader>bi",
        function()
            cb.cbox(13)
        end,
        {desc = "Left fixed box, center text (side)"}
    )

    map({"n", "v"}, "<Leader>be", cb.lbox, {desc = "Left fixed box, left text (round)"})
    map({"n", "v"}, "<Leader>ba", cb.acbox, {desc = "Left center box, center text (round)"})
    map({"n", "v"}, "<Leader>bc", cb.accbox, {desc = "Center center box, center text (round)"})

    -- cline
    map(
        {"n", "i"},
        "<M-w>",
        function()
            -- 2 6 7
            cb.line(6)
        end,
        {desc = "Insert thick line"}
    )

    map("n", "<Leader>b?", cb.catalog, {desc = "Comment box catalog"})
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                        Registers                         │
-- ╰──────────────────────────────────────────────────────────╯
function M.registers()
    g.registers_return_symbol = "⏎"
    g.registers_tab_symbol = "\t" -- "·"
    g.registers_show_empty_registers = 0
    -- g.registers_hide_only_whitespace = 1
    g.registers_window_border = "rounded"
    g.registers_insert_mode = false -- removes <C-R> insert mapping
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                            LF                            │
-- ╰──────────────────────────────────────────────────────────╯
-- function M.lf()
--     g.lf_map_keys = 0
--     g.lf_replace_netrw = 1
--
--     map("n", "<A-o>", ":Lf<CR>")
-- end

function M.lfnvim()
    g.lf_netrw = 1

    require("lf").setup(
        {
            escape_quit = false,
            border = "rounded",
            highlights = {FloatBorder = {guifg = require("kimbox.palette").colors.magenta}}
        }
    )

    map("n", "<C-o>", ":Lf<CR>")
    -- map("n", "<A-o>", ":Lfnvim<CR>")
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                         urlview                          │
-- ╰──────────────────────────────────────────────────────────╯
function M.urlview()
    require("urlview").setup(
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
            navigate_method = "netrw",
            -- Logs user warnings
            debug = true,
            -- Custom search captures
            custom_searches = {
                -- KEY: search source name
                -- VALUE: custom search function or table (map with keys capture, format)
                jira = {
                    capture = "AXIE%-%d+",
                    format = "https://jira.axieax.com/browse/%s"
                }
            }
        }
    )

    require("telescope").load_extension("urlview")
    map("n", "gL", "UrlView", {cmd = true})
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                          trevj                           │
-- ╰──────────────────────────────────────────────────────────╯
function M.trevj()
    require("trevj").setup(
        {
            containers = {
                lua = {
                    table_constructor = {final_separator = ",", final_end_line = true},
                    arguments = {final_separator = false, final_end_line = true},
                    parameters = {final_separator = false, final_end_line = true}
                },
                html = {
                    start_tag = {
                        final_separator = false,
                        final_end_line = true,
                        skip = {tag_name = true}
                    }
                }
            }
        }
    )
    map("n", "gJ", [[:lua require('trevj').format_at_cursor()<CR>]])
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                           Abolish                        │
-- ╰──────────────────────────────────────────────────────────╯
function M.abolish()
    wk.register(
        {
            ["rs"] = "Snake case",
            ["rm"] = "Mixed case",
            ["rc"] = "Camel case",
            ["ru"] = "Upper case",
            ["r-"] = "Dash case",
            ["r."] = "Dot case",
            ["r<Space>"] = "Space case",
            ["rt"] = "Title case"
        },
        {mode = "o"}
    )
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                          Crates                          │
-- ╰──────────────────────────────────────────────────────────╯
function M.crates()
    local crates = require("crates")

    crates.setup(
        {
            smart_insert = true,
            insert_closing_quote = true,
            avoid_prerelease = true,
            autoload = true,
            autoupdate = true,
            loading_indicator = true,
            date_format = "%Y-%m-%d",
            disable_invalid_feature_diagnostic = false
        }
    )

    augroup(
        "lmb__CratesBindings",
        {
            event = "BufEnter",
            pattern = "Cargo.toml",
            command = function()
                local bufnr = nvim.get_current_buf()
                map(
                    "n",
                    "<Leader>ca",
                    function()
                        crates.upgrade_all_crates()
                    end,
                    {buffer = bufnr}
                )

                map(
                    "n",
                    "<Leader>cu",
                    function()
                        crates.upgrade_crate()
                    end,
                    {buffer = bufnr}
                )

                map(
                    "n",
                    "<Leader>ch",
                    function()
                        crates.open_homepage()
                    end,
                    {buffer = bufnr}
                )

                map(
                    "n",
                    "<Leader>cr",
                    function()
                        crates.open_repository()
                    end,
                    {buffer = bufnr}
                )

                map(
                    "n",
                    "<Leader>cd",
                    function()
                        crates.open_documentation()
                    end,
                    {buffer = bufnr}
                )

                wk.register(
                    {
                        ["<Leader>ca"] = "Upgrade all crates",
                        ["<Leader>cu"] = "Upgrade crate",
                        ["<Leader>ch"] = "Open homepage",
                        ["<Leader>cr"] = "Open repository",
                        ["<Leader>cd"] = "Open documentation"
                    }
                )
            end
        }
    )
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                         Projects                         │
-- ╰──────────────────────────────────────────────────────────╯
function M.project()
    -- require("project_nvim").get_recent_projects()

    -- Detection Methods
    -- =src                => Specify root
    -- plain name          => Has a certain directory or file (may be glob
    -- ^fixtures           => Has certain directory as ancestory
    -- >Latex              => Has a certain directory as direct ancestor
    -- !=extras !^fixtures => Exclude pattern

    require("project_nvim").setup(
        {
            -- Manual mode doesn't automatically change your root directory, so you have
            -- the option to manually do so using `:ProjectRoot` command.
            manual_mode = false,
            -- Methods of detecting the root directory. **"lsp"** uses the native neovim
            -- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
            -- order matters: if one is not detected, the other is used as fallback. You
            -- can also delete or rearangne the detection methods.
            detection_methods = {"lsp", "pattern"},
            -- All the patterns used to detect root dir, when **"pattern"** is in
            -- detection_methods
            patterns = {".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json"},
            -- Table of lsp clients to ignore by name
            -- eg: { "efm", ... }
            ignore_lsp = {},
            -- Don't calculate root dir on specific directories
            -- Ex: { "~/.cargo/*", ... }
            exclude_dirs = {},
            -- Show hidden files in telescope
            show_hidden = false,
            -- When set to false, you will get a message when project.nvim changes your
            -- directory.
            silent_chdir = true,
            -- Path where project.nvim will store the project history for use in
            -- telescope
            datapath = fn.stdpath("data")
        }
    )

    require("telescope").load_extension("projects")
    map("n", "<LocalLeader>p", "Telescope projects", {cmd = true})
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                       VisualMulti                        │
-- ╰──────────────────────────────────────────────────────────╯
function M.visualmulti()
    -- g.VM_theme = "purplegray"
    g.VM_highlight_matches = ""
    g.VM_show_warnings = 0
    g.VM_silent_exit = 1
    g.VM_default_mappings = 1
    -- https://github.com/mg979/vim-visual-multi/wiki/Mappings
    g.VM_maps = {
        Delete = "d",
        Undo = "u",
        Redo = "U",
        ["Select Operator"] = "v",
        ["Find Operator"] = "m",
        ["Select Cursor Up"] = "<M-C-Up>",
        ["Select Cursor Down"] = "<M-C-Down>",
        ["Move Left"] = "<M-C-Left>",
        ["Move Right"] = "<M-C-Right>",
        ["Find Next"] = "]",
        ["Find Prev"] = "[",
        ["Goto Next"] = "}",
        ["Goto Prev"] = "{",
        ["Seek Next"] = "<C-f>",
        ["Seek Prev"] = "<C-b>",
        ["Skip Region"] = "q",
        ["Remove Region"] = "Q",
        ["Invert Direction"] = "o",
        ["Surround"] = "S",
        ["Replace Pattern"] = "R",
        ["Tools Menu"] = "<Leader>`",
        ["Show Regisers"] = '<Leader>"',
        ["Case Setting"] = "<Leader>c",
        ["Toggle Whole Word"] = "<Leader>w",
        ["Transpose"] = "<Leader>t",
        ["Align"] = "<Leader>a",
        ["Duplicate"] = "<Leader>d",
        ["Merge Regions"] = "<Leader>m"
    }
    map("n", "<C-Up>", "<Plug>(VM-Add-Cursor-Up)")
    map("n", "<C-Down>", "<Plug>(VM-Add-Cursor-Down)")
    map("n", "<C-n>", "<Plug>(VM-Find-Under)")
    map("x", "<C-n>", "<Plug>(VM-Find-Subword-Under)")
    map("n", [[<Leader>\]], "<Plug>(VM-Add-Cursor-At-Pos)")
    map("n", "<Leader>/", "<Plug>(VM-Start-Regex-Search)")
    map("n", "<Leader>A", "<Plug>(VM-Select-All)")
    map("x", "<Leader>A", "<Plug>(VM-Visual-All)")
    map("n", "<Leader>gs", "<Plug>(VM-Reselect-Last)")
    map("n", "<M-S-i>", "<Plug>(VM-Select-Cursor-Up)")
    map("n", "<M-S-o>", "<Plug>(VM-Select-Cursor-Down)")
    map("n", "g/", "<Cmd>VMSearch<CR>")

    augroup(
        "VisualMulti",
        {
            event = "User",
            pattern = "visual_multi_start",
            command = function()
                require("common.vm").start()
            end
        },
        {
            event = "User",
            pattern = "visual_multi_exit",
            command = function()
                require("common.vm").exit()
            end
        },
        {
            event = "User",
            pattern = "visual_multi_mappings",
            command = function()
                require("common.vm").mappings()
            end
        }
    )
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                       Git Conflict                       │
-- ╰──────────────────────────────────────────────────────────╯
function M.git_conflict()
    require("git-conflict").setup(
        {
            {
                default_mappings = true,
                disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
                highlights = {
                    -- They must have background color, otherwise the default color will be used
                    incoming = "DiffText",
                    current = "DiffAdd"
                }
            }
        }
    )
    map("n", "co", "<Plug>(git-conflict-ours)")
    map("n", "cb", "<Plug>(git-conflict-both)")
    map("n", "c0", "<Plug>(git-conflict-none)")
    map("n", "ct", "<Plug>(git-conflict-theirs)")
    map("n", "[c", "<Plug>(git-conflict-next-conflict)")
    map("n", "]c", "<Plug>(git-conflict-prev-conflict)")
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                       regexplainer                       │
-- ╰──────────────────────────────────────────────────────────╯
function M.regexplainer()
    require("regexplainer").setup {
        mode = "narrative", -- TODO: 'ascii', 'graphical'
        -- automatically show the explainer when the cursor enters a regexp
        auto = false,
        -- filetypes (i.e. extensions) in which to run the autocommand
        filetypes = {
            "html",
            "js",
            "cjs",
            "mjs",
            "ts",
            "jsx",
            "tsx",
            "cjsx",
            "mjsx"
            -- "rs"
        },
        debug = false, -- Whether to log debug messages
        display = "popup", -- 'split', 'popup', 'pasteboard'
        popup = {
            border = {
                padding = {1, 2},
                style = "solid"
            }
        },
        mappings = {
            toggle = "gR",
            show = "gS"
            -- hide = 'gH',
            -- show_split = 'gP',
            -- show_popup = 'gU',
        },
        narrative = {
            separator = "\n"
        }
    }
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                          eregex                          │
-- ╰──────────────────────────────────────────────────────────╯
function M.eregex()
    map("n", "<Leader>/", "<cmd>call eregex#toggle()<CR>", {desc = "Toggle eregex"})
end

-- ╭──────────────────────────────────────────────────────────╮
-- │                        Neoscroll                         │
-- ╰──────────────────────────────────────────────────────────╯
-- function M.neoscroll()
--     require("neoscroll").setup(
--         {
--             -- All these keys will be mapped to their corresponding default scrolling animation
--             -- mappings = {
--             --     "<C-u>",
--             --     "<C-d>",
--             --     "<C-b>",
--             --     "<C-f>",
--             --     "<C-y>",
--             --     "<C-e>",
--             --     "zt",
--             --     "zz",
--             --     "zb"
--             -- },
--             hide_cursor = true, -- Hide cursor while scrolling
--             stop_eof = true, -- Stop at <EOF> when scrolling downwards
--             use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
--             respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
--             cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
--             easing_function = nil, -- Default easing function
--             pre_hook = nil, -- Function to run before the scrolling animation starts
--             post_hook = nil, -- Function to run after the scrolling animation ends
--             performance_mode = false -- Disable "Performance Mode" on all buffers.
--         }
--     )
--
--     local t = {}
--
--     t["<C-u>"] = {"scroll", {"-vim.wo.scroll", "true", "250"}}
--     t["<C-d>"] = {"scroll", {"vim.wo.scroll", "true", "250"}}
--     -- t["<C-b>"] = {"scroll", {"-vim.api.nvim_win_get_height(0)", "true", "250"}}
--     -- t["<C-f>"] = {"scroll", {"vim.api.nvim_win_get_height(0)", "true", "250"}}
--     t["<C-y>"] = {"scroll", {"-0.10", "false", "80"}}
--     t["<C-e>"] = {"scroll", {"0.10", "false", "80"}}
--     t["zt"] = {"zt", {"150"}}
--     t["zz"] = {"zz", {"150"}}
--     t["zb"] = {"zb", {"150"}}
--     -- t["gg"] = {"scroll", {"-2*vim.api.nvim_buf_line_count(0)", "true", "1", "5", e}}
--     -- t["G"] = {"scroll", {"2*vim.api.nvim_buf_line_count(0)", "true", "1", "5", e}}
--
--     require("neoscroll.config").set_mappings(t)
-- end

-- ╭──────────────────────────────────────────────────────────╮
-- │                         Cutlass                          │
-- ╰──────────────────────────────────────────────────────────╯
-- function M.cutlass()
--     require("cutlass").setup({cut_key = nil, override_del = nil, exclude = {"vx"}})
-- end

-- ╭──────────────────────────────────────────────────────────╮
-- │                     Session Manager                      │
-- ╰──────────────────────────────────────────────────────────╯
-- function M.session_manager()
--     require("session_manager").setup(
--         {
--             sessions_dir = Path:new(fn.stdpath("data"), "sessions"),
--             path_replacer = "__",
--             colon_replacer = "++",
--             autoload_mode = require("session_manager.config").AutoloadMode.LastSession,
--             autosave_last_session = true,
--             autosave_ignore_not_normal = true,
--             autosave_ignore_filetypes = {
--                 -- All buffers of these file types will be closed before the session is saved.
--                 "gitcommit"
--             },
--             autosave_only_in_session = false,
--             max_path_length = 80
--         }
--     )
-- end

-- ╭──────────────────────────────────────────────────────────╮
-- │                         incline                          │
-- ╰──────────────────────────────────────────────────────────╯
-- function M.incline()
--     require("incline").setup {
--         render = function(props)
--             local bufname = vim.api.nvim_buf_get_name(props.buf)
--             if bufname == "" then
--                 return "[No name]"
--             else
--                 bufname = vim.fn.fnamemodify(bufname, ":t")
--             end
--             return bufname
--         end,
--         debounce_threshold = 30,
--         window = {
--             width = "fit",
--             placement = {horizontal = "right", vertical = "top"},
--             margin = {
--                 horizontal = {left = 1, right = 1},
--                 vertical = {bottom = 0, top = 1}
--             },
--             padding = {left = 1, right = 1},
--             padding_char = " ",
--             zindex = 100
--         },
--         ignore = {
--             floating_wins = true,
--             unlisted_buffers = true,
--             filetypes = {},
--             buftypes = "special",
--             wintypes = "special"
--         }
--     }
-- end

-- function M.neoterm()
--   g.neoterm_default_mod = "belowright" -- open terminal in bottom split
--   g.neoterm_size = 14 -- terminal split size
--   g.neoterm_autoscroll = 1 -- scroll to the bottom
--
--   map("n", "<Leader>rr", "<Cmd>execute v:count.'Tclear'<CR>")
--   map("n", "<Leader>rt", ":Ttoggle<CR>")
--   map("n", "<Leader>ro", ":Ttoggle<CR> :Ttoggle<CR>")
-- end

-- ╭──────────────────────────────────────────────────────────╮
-- │                       Delimitmate                        │
-- ╰──────────────────────────────────────────────────────────╯
-- function M.delimitmate()
--   g.delimitMate_jump_expansion = 1
--   g.delimitMate_expand_cr = 2
--
--   cmd("au FileType html let b:delimitMate_matchpairs = '(:),[:],{:}'")
--   cmd("au FileType vue let b:delimitMate_matchpairs = '(:),[:],{:}'")
--
--   map(
--       "i", "<CR>", ("pumvisible() ? %s : %s . \"<Plug>delimitMateCR\""):format(
--           [["\<C-y>"]], [[(getline('.') =~ '^\s*$' ? '' : "\<C-g>u")]]
--       ), { noremap = false, expr = true }
--   )
-- end

-- ╭──────────────────────────────────────────────────────────╮
-- │                          Sneak                           │
-- ╰──────────────────────────────────────────────────────────╯
-- function M.sneak()
--   g["sneak#label"] = 1
--
--   -- map(
--   --     { "n", "x" }, "f", "sneak#is_sneaking() ? '<Plug>Sneak_s' : 'f'",
--   --     { noremap = false, expr = true }
--   -- )
--   -- map(
--   --     { "n", "x" }, "F", "sneak#is_sneaking() ? '<Plug>Sneak_S' : 'F'",
--   --     { noremap = false, expr = true }
--   -- )
--
--   map("n", "f", "<Plug>Sneak_s", { noremap = false })
--   map("n", "F", "<Plug>Sneak_S", { noremap = false })
--
--   -- Repeat the last Sneak
--   map("n", "gs", "f<CR>", { noremap = false })
--   map("n", "gS", "F<CR>", { noremap = false })
-- end

-- ╭──────────────────────────────────────────────────────────╮
-- │                        AbbrevMan                         │
-- ╰──────────────────────────────────────────────────────────╯
-- function M.abbrevman()
--     require("abbrev-man").setup(
--         {
--             load_natural_dictionaries_at_startup = true,
--             load_programming_dictionaries_at_startup = true,
--             natural_dictionaries = {["nt_en"] = {["adn"] = "and"}},
--             programming_dictionaries = {["pr_py"] = {}}
--         }
--     )
-- end

-- ╭──────────────────────────────────────────────────────────╮
-- │                         Spectre                          │
-- ╰──────────────────────────────────────────────────────────╯
-- function M.spectre()
--     require("spectre").setup()
--
--     -- require("spectre.actions").get_current_entry()
--     -- require("spectre.actions").get_all_entries()
--     -- require("spectre.actions").get_state()
--     -- require("spectre").open(
--     --     {
--     --         is_insert_mode = true,
--     --         cwd = "~/.config/nvim",
--     --         search_text = "test",
--     --         replace_text = "test",
--     --         path = "lua/**/*.lua"
--     --     }
--     -- )
--
--     command(
--         "SpectreOpen",
--         function()
--             require("spectre").open()
--         end
--     )
-- end

-- ╭──────────────────────────────────────────────────────────╮
-- │                       QFReflector                        │
-- ╰──────────────────────────────────────────────────────────╯
-- function M.qf_reflector()
--     g.qf_modifiable = 1
--     g.qf_write_changes = 1
-- end

-- ╭──────────────────────────────────────────────────────────╮
-- │                         Anywise                          │
-- ╰──────────────────────────────────────────────────────────╯
-- function M.anywise()
--     require("anywise_reg").setup(
--         {
--             operators = {"y", "d", "c"},
--             textobjects = {
--                 {"i", "a"},
--                 {"w", "W", "f", "c"}
--             },
--             paste_keys = {
--                 ["p"] = "p"
--             },
--             register_print_cmd = true
--         }
--     )
-- end

-- ╭──────────────────────────────────────────────────────────╮
-- │                         Minimap                          │
-- ╰──────────────────────────────────────────────────────────╯
-- function M.minimap()
--     map("n", "<Leader>mi", ":MinimapToggle<CR>")
--
--     g.minimap_width = 10
--     g.minimap_auto_start = 0
--     g.minimap_auto_start_win_enter = 1
--     g.minimap_highlight_range = 1
--     g.minimap_block_filetypes = {"fugitive", "nerdtree", "help", "vista"}
--     g.minimap_close_filetypes = {"startify", "netrw", "vim-plug", "floaterm"}
--     g.minimap_block_buftypes = {
--         "nofile",
--         "nowrite",
--         "quickfix",
--         "terminal",
--         "prompt"
--     }
-- end

-- ╭──────────────────────────────────────────────────────────╮
-- │                          Luadev                          │
-- ╰──────────────────────────────────────────────────────────╯
-- function M.luadev()
--     map("n", "<Leader>x<CR>", "<Plug>(Luadev-RunLine)", {noremap = false})
--     map("n", "<Leader>x.", "<Plug>(Luadev-Run)", {noremap = false})
-- end

return M
