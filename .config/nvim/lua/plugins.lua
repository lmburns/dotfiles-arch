local fn = vim.fn
local uv = vim.loop
local cmd = vim.cmd
local uva = require("uva")

local install_path = ("%s/%s"):format(Rc.dirs.data, "/site/pack/packer/opt/packer.nvim")
uva.stat(install_path):catch(function()
    fn.system("git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end)

local Path = require("plenary.path")
local Job = require("plenary.job")

cmd.packadd("packer.nvim")
local packer = require("packer")

packer.on_compile_done = function()
    local fp = assert(io.open(packer.config.compile_path, "r+"))
    local wbuf = {}
    local key_state = 0
    for line in fp:lines() do
        if key_state == 0 then
            table.insert(wbuf, line)
            if line:find("Keymap lazy%-loads") then
                key_state = 1
                table.insert(wbuf, [[vim.defer_fn(function()]])
            end
        elseif key_state == 1 then
            if line == "" then
                key_state = 2
                table.insert(wbuf, ("end, %d)"):format(15))
            end
            local _, e1 = line:find("vim%.cmd")
            if line:find("vim%.cmd") then
                local s2, e2 = line:find("%S+%s", e1 + 1)
                local map_mode = line:sub(s2, e2)
                line = ("pcall(vim.cmd, %s<unique>%s)"):format(map_mode, line:sub(e2 + 1))
            end
            table.insert(wbuf, line)
        else
            table.insert(wbuf, line)
        end
    end

    if key_state == 2 then
        fp:seek("set")
        fp:write(table.concat(wbuf, "\n"))
    end

    fp:close()
    -- vim.cmd [[doautocmd User PackerCompileDone]]
end

-- packer.on_complete = function()
--     cmd("doau User PackerComplete")
--     nvim.p.TSNote("Packer completed")
-- end

packer.init({
    compile_path = ("%s/plugin/packer_compiled.lua"):format(Rc.dirs.config),
    snapshot_path = ("%s/snapshot/packer.nvim"):format(Rc.dirs.config),
    -- snapshot_path = ("%s/snapshot/packer.nvim"):format(Rc.dirs.cache),
    -- opt_default = false,
    auto_clean = true,
    auto_reload_compiled = true, -- Automatically reload the compiled file after creating it.
    autoremove = false,
    compile_on_sync = true,      -- During sync(), run packer.compile()
    ensure_dependencies = true,  -- Should packer install plugin dependencies?
    transitive_disable = true,   -- Automatically disable dependencies of disabled plugins
    display = {
        non_interactive = false,
        header_lines = 2,
        title = " packer.nvim",
        working_sym = " ",
        error_sym = "",
        done_sym = "",
        removed_sym = "",
        moved_sym = " ",
        show_all_info = true,
        prompt_border = "rounded",
        open_cmd = [[tabedit]],
        keybindings = {
            prompt_revert = "R",
            diff = "D",
            retry = "r",
            quit = "q",
            toggle_info = "<CR>",
        },
        open_fn = function()
            return require("packer.util").float({border = "rounded"})
        end,
    },
    log = {level = "info"},
    profile = {enable = true},
})

PATCH_DIR = ("%s/patches"):format(Rc.dirs.config)

local handlers = {
    conf = function(_plugins, plugin, value)
        if value:match("^plugs%..+%.") then
            local _, _, m1, m2 = value:find("^plugs%.(.+)%.(.+)")
            plugin.config = ([[require('plugs.%s').%s()]]):format(m1, m2)
        elseif value:match("^plugs%.") then
            plugin.config = ([[require('%s')]]):format(value)
        else
            plugin.config = ([[require('plugs.config').%s()]]):format(value)
        end
    end,
    disablep = function(_, plugin, _value)
        -- Do not override plugins that have been disabled with the `disable` key
        if plugin.disable == nil then
            plugin.disable = require("usr.control")[plugin.short_name]
        end
    end,
    deb = function(_, plugin, _)
        if plugin.disable == true then
            p(plugin)
        end
    end,
    patch = function(_plugins, plugin, value)
        -- local run_hook = plugin_utils.post_update_hook

        -- This is preferred because you can provide own error message
        vim.validate({
            value = {
                value,
                function(n)
                    local t = type(n)
                    return t == "string" or t == "boolean"
                end,
                ("%s: must be a string or boolean"):format(plugin.short_name),
            },
        })

        if type(value) == "string" then
            value = fn.expand(value)
        else
            value = ("%s/%s.patch"):format(PATCH_DIR, plugin.short_name)
        end

        plugin.run = function()
            if uv.fs_stat(value) then
                nvim.p(("Applying patch: %s"):format(plugin.short_name), "WarningMsg")
                cmd.lcd(plugin.install_path)
                Job:new({
                    command = "patch",
                    args = {"-s", "-N", "-p1", "-i", value},
                    on_exit = function(_, ret)
                        if ret ~= 0 then
                            nvim.p(
                                ("Unable to apply patch to %s"):format(plugin.name),
                                "ErrorMsg"
                            )
                        end
                    end,
                }):start()
            else
                nvim.p("Patch file does not exist", "ErrorMsg")
            end
        end
    end,
}

---Specify a configuration in `common.config` or its own file
packer.set_handler("conf", handlers.conf)

---Specify the disable marker for each plugin
---Can be disabled easier in the `control.lua` file
packer.set_handler(1, handlers.disablep)

-- packer.set_handler("deb", handlers.deb)
packer.set_handler(1, handlers.deb)

---Apply a patch to the given plugin
packer.set_handler("patch", handlers.patch)

---Use a local plugin found on the filesystem
---@param url string link to repo
---@param path? string path to repo
---@return string
local function prefer_local(url, path)
    if not path then
        local name = url:match("[^/]*$")
        path = "~/projects/nvim/" .. name
    end
    return uv.fs_stat(fn.expand(path)) ~= nil and path or url
end

return packer.startup(
    {
        function(use, use_rocks)
            -- https://rrthomas.github.io/lrexlib/manual.html
            use_rocks("lrexlib-pcre2") -- rex_pcre2
            -- use_rocks("lpeg")
            use_rocks("carray")

            ---@type fun(v: PackerPlugin)
            local use = use

            -- Package manager
            use({
                "wbthomason/packer.nvim",
                opt = true,
                setup = function()
                    if vim.g.loaded_visual_multi == 1 then
                        vim.schedule(
                            function()
                                fn["vm#plugs#permanent"]()
                            end
                        )
                    end
                end,
            })

            -- Cache startup
            -- use({"lewis6991/impatient.nvim"})
            use({
                "dstein64/vim-startuptime",
                cmd = "StartupTime",
                config = function()
                    vim.g.startuptime_tries = 15
                    vim.g.startuptime_exe_args = {"+let g:auto_session_enabled = 0"}
                end,
            })

            use({"alx741/vinfo", cmd = {"Vinfo", "VinfoClean", "VinfoNext", "VinfoPrevious"}})
            use({"HiPhish/info.vim", cmd = "Info"})

            -- ╭──────────────────────────────────────────────────────────╮
            -- │                         Library                          │
            -- ╰──────────────────────────────────────────────────────────╯
            use({"tpope/vim-repeat"})
            use({"glepnir/nerdicons.nvim", conf = "nerdicons", cmd = "NerdIcons"})

            use({"nvim-lua/popup.nvim"})
            use({"nvim-lua/plenary.nvim"})
            use({"kevinhwang91/promise-async"})
            -- use({"folke/neodev.nvim", conf = "neodev"})
            use({"norcalli/nvim.lua"})
            use({"arsham/arshlib.nvim", requires = {"nvim-lua/plenary.nvim"}})
            use({"tami5/sqlite.lua"})
            use({"kyazdani42/nvim-web-devicons", conf = "devicons"})
            use({"stevearc/dressing.nvim", event = "BufWinEnter", conf = "plugs.dressing"})

            -- ============================= Keybinding =========================== [[[
            use({"folke/which-key.nvim", conf = "plugs.which-key"})
            -- use({
            --     "mrjones2014/legendary.nvim",
            --     conf = "plugs.legendary",
            --     requires = {"stevearc/dressing.nvim", "folke/which-key.nvim"},
            -- })
            -- ]]] === Keybinding ===

            -- ========================== Fixes / Addons ========================== [[[
            use({
                "tweekmonster/helpful.vim",
                desc = "See what version (n)vim feature was added",
                cmd = "HelpfulVersion",
            })
            -- use({"machakann/vim-highlightedundo", conf = "hlundo"})
            use({"antoinemadec/FixCursorHold.nvim", opt = false, event = "CursorHold"})
            use({"max397574/better-escape.nvim", conf = "better_esc", event = "InsertEnter"})
            use({
                "mrjones2014/smart-splits.nvim",
                conf = "smartsplits",
                desc = "Navigate split panes",
                keys = {
                    {"n", "<C-Up>"},
                    {"n", "<C-Down>"},
                    {"n", "<C-Left>"},
                    {"n", "<C-Right>"},
                },
            })
            use({"aserowy/tmux.nvim", conf = "tmux"})
            use({
                "tversteeg/registers.nvim",
                conf = "registers",
                keys = {{"n", '"'}, {"i", "<C-r>"}},
                cmd = "Registers",
            })
            -- use({
            --     "yegappan/mru",
            --     conf = "mru",
            --     keys = {{"n", "qr"}, {"n", "qR"}},
            -- })
            use({
                "AndrewRadev/bufferize.vim",
                desc = "Get command output in another buffer",
                cmd = "Bufferize",
            })
            use({"tpope/vim-scriptease", cmd = {"Scriptnames"}})
            use({
                "inkarkat/vim-ingo-library",
                requires = {"inkarkat/vim-SpellCheck", after = {"vim-ingo-library"}},
                cmd = {"SpellLCheck", "SpellCheck"},
                keys = {{"n", "qs"}},
            })

            -- use({
            --     "qtc-de/vve",
            --     conf = "vve",
            --     desc = "Encoding capabilities",
            -- })

            -- use({
            --     "m4xshen/smartcolumn.nvim",
            --     conf = "smartcolumn",
            --     event = "BufEnter",
            -- })

            -- use({
            --     "stevearc/resession.nvim",
            --     after = "telescope.nvim",
            --
            --     conf = "plugs.resession",
            --     desc = "Session management",
            --     requires = {
            --         "stevearc/aerial.nvim",
            --         "stevearc/overseer.nvim",
            --     },
            -- })


            -- rickhowe/diffchar.vim
            use({
                "AndrewRadev/linediff.vim",
                conf = "linediff",
                cmd = "Linediff",
                keys = {
                    {"n", "<Leader>ld"},
                    {"x", "<Leader>ld"},
                    {"n", "<Leader>lD"},
                },
            })
            -- use({
            --     "will133/vim-dirdiff",
            --     conf = "dirdiff",
            --     cmd = "DirDiff",
            -- })

            use({
                "arthurxavierx/vim-caser",
                setup = [[vim.g.caser_prefix = "cr"]],
                conf = "caser",
                keys = {
                    {"n", "crm"},
                    {"n", "crp"},
                    {"n", "crc"},
                    {"n", "crt"},
                    {"n", "cr<Space>"},
                    {"n", "cr-"},
                    {"n", "crk"},
                    {"n", "crK"},
                    {"n", "cr."},
                    {"n", "cr_"},
                    {"n", "crU"},
                    {"n", "cru"},
                    {"n", "crl"},
                    {"n", "crs"},
                    {"n", "crd"},
                    {"n", "crS"},
                },
            })

            -- :E2v = (\d{1,3})(?=(\d\d\d)+($|\D))
            -- Match = :M/<Items\s+attr="media">.+?<\/Items>/Im
            -- Substitute = :'<,'>S/(\d{1,3})(?=(\d\d\d)+($|\D))/\1,/g
            -- Global = :G/^begin$/+1;/^end$/-1:S/\l+/\U&/g
            -- :V
            use({
                "ZSaberLv0/eregex.vim",
                cmd = {"E2v", "S", "M", "V"}, -- "G"
                setup = [[vim.g.eregex_default_enable = 0]],
                keys = {{"n", "<Leader>es"}, {"n", "<Leader>S"}, {"n", ",/"}},
                conf = "eregex",
                desc = "Ruby/Perl style regex for Vim",
            })

            use({
                "mg979/vim-visual-multi",
                setup = [[vim.g.VM_leader = '<Space>']],
                keys = {
                    {"n", "<C-n>"},
                    {"x", "<C-n>"},
                    {"n", "<C-S-Up>"},
                    {"n", "<C-S-Down>"},
                    {"n", "<M-S-i>"},
                    {"n", "<M-S-o>"},
                    {"n", "<C-M-S-Right>"},
                    {"n", "<C-M-S-Left>"},
                    {"n", [[<Leader>\]]},
                    {"n", [[<Leader>/]]},
                    {"x", [[<Leader>/]]},
                    {"n", "<Leader>A"},
                    {"x", "<Leader>A"},
                    {"x", ";A"},
                    {"x", ";a"},
                    {"x", ";F"},
                    {"x", ";C"},
                    {"n", "<Leader>gs"},
                    {"n", "g/"},
                },
                cmd = {"VMSearch"},
                conf = "plugs.vm",
                wants = {"nvim-hlslens", "nvim-autopairs"},
            })

            use({
                "kevinhwang91/suda.vim",
                keys = {{"n", "<Leader>W"}},
                cmd = {"SudaRead", "SudaWrite"},
                conf = "suda",
            })

            -- use({"skywind3000/asyncrun.vim", cmd = "AsyncRun"})
            -- ]]] === Fixes ===

            -- =========================== Colorscheme ============================ [[[
            local colorscheme = "kimbox"
            -- Needed for some themes
            use({"rktjmp/lush.nvim"})

            use({
                "rebelot/kanagawa.nvim",
                event = "ColorSchemePre kanagawa",
                config = "plugs.kimbox.kanagawa",
            })
            use({
                "catppuccin/nvim",
                as = "catppuccin",
                event = "ColorSchemePre catpuccin",
                config = "plugs.kimbox.catpuccin",
            })

            -- use({"kvrohit/mellow.nvim"})
            -- use({"eddyekofo94/gruvbox-flat.nvim"})
            -- use({"sainnhe/gruvbox-material"})
            -- use({"sainnhe/edge"})
            -- use({"sainnhe/everforest"})
            -- use({"sainnhe/sonokai"})
            -- use({"glepnir/oceanic-material", event = "ColorSchemePre oceanic_material"})
            -- use({"cocopon/iceberg.vim", event = "ColorSchemePre iceberg"})

            -- use({"folke/tokyonight.nvim", event = "ColorSchemePre tokyonight"})
            -- use({"pineapplegiant/spaceduck", event = "ColorSchemePre spaceduck"})
            -- use({"franbach/miramare", event = "ColorSchemePre miramare"})

            -- use({"EdenEast/nightfox.nvim"})
            -- use({"rose-pine/neovim", as = "rose-pine"})
            -- use({"meliora-theme/neovim", as = "meliora"})
            -- use({"marko-cerovac/material.nvim"})
            -- use({"savq/melange"})

            -- use({"KeitaNakamura/neodark.vim"})
            -- use({"tyrannicaltoucan/vim-deep-space"})
            -- use({"arturgoms/moonbow.nvim"})
            -- use({"vv9k/bogster"})
            -- use({"bluz71/vim-nightfly-guicolors"})
            -- use({"haishanh/night-owl.vim"})

            -- use({"ackyshake/Spacegray.vim"})
            -- use({"tiagovla/tokyodark.nvim"})

            -- Need to make a new theme for this
            -- use({"ghifarit53/daycula-vim"})
            -- use({"rmehri01/onenord.nvim"})
            -- use({"kyazdani42/blue-moon"})
            -- use({"rockyzhang24/arctic.nvim"})

            -- use({"shaunsingh/oxocarbon.nvim", run = "./install.sh"})
            -- use({"levuaska/levuaska.nvim"})
            -- use({"wadackel/vim-dogrun"})
            -- use({"sam4llis/nvim-tundra"})

            use({"lmburns/kimbox", conf = "plugs.kimbox"})
            -- ]]] === Colorscheme ===

            -- ============================== Debugging ============================ [[[
            use({
                "mfussenegger/nvim-dap",
                conf = "plugs.dap",
                cmds = {"Debug", "DapREPL", "DapLaunch", "DapRun"},
                keys = {
                    {"n", "<LocalLeader>dd"},
                    {"n", "<LocalLeader>dc"},
                    {"n", "<LocalLeader>db"},
                    {"n", "<LocalLeader>dr"},
                    {"n", "<LocalLeader>dR"},
                    {"n", "<LocalLeader>dl"},
                    {"n", "<LocalLeader>dt"},
                    {"n", "<LocalLeader>dU"},
                    {"n", "<LocalLeader>dv"},
                },
                requires = {
                    {"jbyuki/one-small-step-for-vimkind", after = "nvim-dap"},
                    {"theHamsta/nvim-dap-virtual-text", after = "nvim-dap"},
                    {"rcarriga/nvim-dap-ui", after = "nvim-dap"},
                    {"mfussenegger/nvim-dap-python", after = "nvim-dap"},
                    {
                        "nvim-telescope/telescope-dap.nvim",
                        after = "nvim-dap",
                        config = [[require("telescope").load_extension("dap")]],
                    },
                    -- {"leoluz/nvim-dap-go"},
                    -- {"suketa/nvim-dap-ruby"},
                },
            })

            -- use({
            --     "rcarriga/neotest",
            --     conf = "plugs.neotest",
            --     after = {"overseer.nvim"},
            --     -- module = {"neotest", "overseer"},
            --     -- event = "BufRead",
            --     wants = "overseer.nvim",
            --     cmd = {
            --         "TestNear",
            --         "TestCurrent",
            --         "TestSummary",
            --         "TestOutput",
            --         "TestStop",
            --         "TestAttach",
            --         "TestStrat",
            --     },
            --     requires = {
            --         "nvim-treesitter/nvim-treesitter",
            --         "antoinemadec/FixCursorHold.nvim",
            --         "nvim-neotest/neotest-python",
            --         {"nvim-neotest/neotest-plenary", requires = {"nvim-lua/plenary.nvim"}},
            --         "nvim-neotest/neotest-go",
            --         "nvim-neotest/neotest-vim-test",
            --         "stevearc/dressing.nvim",
            --         -- "haydenmeade/neotest-jest"
            --         -- "rouge8/neotest-rust"
            --         -- "vim-test/vim-test"
            --     },
            -- })

            -- ========================== Task Runner ============================= [[[
            use({
                "stevearc/overseer.nvim",
                desc = "Task runner",
                conf = "plugs.overseer",
                requires = {"stevearc/dressing.nvim", "nvim-telescope/telescope.nvim"},
                -- after = {"dressing.nvim", "telescope.nvim"},
                -- module = "overseer",
                -- event = "BufRead",
                keys = {
                    {"n", "<Leader>um"},
                    {"n", "<Leader>uc"},
                    {"n", "<Leader>ul"},
                    {"n", "<Leader>ub"},
                    {"n", "<Leader>uq"},
                    {"n", "<Leader>ua"},
                    {"n", "<Leader>ur"},
                    {"n", "<Leader>u<CR>"},
                    {"n", "<Leader>uR"},
                },
                cmd = {
                    "O",
                    "OverseerOpen",
                    "OverseerClose",
                    "OverseerToggle",
                    "OverseerSaveBundle",
                    "OverseerLoadBundle",
                    "OverseerDeleteBundle",
                    "OverseerRunCmd",
                    "OverseerRun",
                    "OverseerBuild",
                    "OverseerQuickAction",
                    "OverseerTaskAction",
                },
            })
            -- ]]] === Task Runner ===

            use({
                "rafcamlet/nvim-luapad",
                cmd = {"Luapad", "LuaRun"},
                conf = "luapad",
            })

            use({"milisims/nvim-luaref", ft = "lua", cmd = {"help"}})
            use({"nanotee/luv-vimdocs", ft = "lua", cmd = {"help"}})

            -- ]]] === Debugging ===

            -- ============================ Neo/Floaterm =========================== [[[
            use({
                "voldikss/fzf-floaterm",
                requires = {"voldikss/vim-floaterm"},
                conf = "plugs.neoterm.floaterm",
            })

            use({
                "akinsho/toggleterm.nvim",
                conf = "plugs.neoterm",
                -- keys = {"gzo", "gzz", "<C-\\>"},
                -- cmd = {"T", "TR", "TP", "VT"}
            })

            use({
                "willothy/flatten.nvim",
                conf = "plugs.neoterm.flatten",
                -- event = "TermOpen",
            })
            -- ]]] === Floaterm ===

            -- ============================ File Manager =========================== [[[
            use({
                "kevinhwang91/rnvimr",
                conf = "plugs.rnvimr",
                keys = {"n", "<M-i>"},
                cmd = {"RnvimrToggle"},
            })
            use({
                prefer_local("lf.nvim"),
                conf = "lfnvim",
                -- cmd = {"Lf"},
                -- keys = {{"n", "<A-o>"}},
                after = {colorscheme, "toggleterm.nvim"},
                wants = "toggleterm.nvim",
                requires = {"nvim-lua/plenary.nvim", "akinsho/toggleterm.nvim"},
            })
            use({"ptzz/lf.vim", conf = "lf"})

            -- ]]] === File Manager ===

            -- =========================== BetterQuickFix ========================== [[[
            use({"kevinhwang91/nvim-bqf", ft = {"qf"}, conf = "plugs.bqf"})
            use({
                "arsham/listish.nvim",
                requires = {"arsham/arshlib.nvim", "norcalli/nvim.lua"},
                conf = "listish",
            })
            -- ]]] === BetterQuickFix ===

            -- ============================ EasyAlign ============================= [[[
            use({
                "junegunn/vim-easy-align",
                conf = "plugs.easy-align",
                keys = {
                    {"n", "ga"},
                    {"x", "ga"},
                    {"x", "<Leader>ga"},
                    {"x", "<Leader>gi"},
                    {"x", "<Leader>gs"},
                },
                cmd = {"EasyAlign", "LiveEasyAlign"},
            })
            -- ]]] === EasyAlign ===

            -- ============================ Open Browser =========================== [[[
            -- use({"tyru/open-browser.vim", conf = "open_browser"})
            use({"axieax/urlview.nvim", conf = "urlview", after = "telescope.nvim"})
            use({"xiyaowong/link-visitor.nvim", conf = "link_visitor"})
            -- ]]] === Open Browser ===

            -- =============================== Marks ============================== [[[
            use({"chentoast/marks.nvim", conf = "plugs.marks", event = "BufWinEnter"})
            -- ]]] === Marks ===

            -- ============================== HlsLens ============================= [[[
            use({
                "kevinhwang91/nvim-hlslens",
                conf = "hlslens",
                requires = {"haya14busa/vim-asterisk"},
                wants = "nvim-scrollbar",
                -- FIX: Lazy loading this doesn't work anymore
                -- keys = {
                --     {"n", "n"},
                --     {"x", "n"},
                --     {"o", "n"},
                --     {"n", "N"},
                --     {"x", "N"},
                --     {"o", "N"},
                --     {"n", "/"},
                --     {"n", "?"},
                --     {"n", "*"},
                --     {"x", "*"},
                --     {"n", "#"},
                --     {"x", "#"},
                --     {"n", "g*"},
                --     {"x", "g*"},
                --     {"n", "g#"},
                --     {"x", "g#"}
                -- }
            })

            use({
                "edluffy/specs.nvim",
                conf = "specs",
                after = "nvim-hlslens",
                desc = "Keep an eye on where the cursor moves",
            })
            -- ]]] === HlsLens ===

            -- ============================ Scrollbar ============================= [[[
            use({
                "petertriho/nvim-scrollbar",
                requires = "kevinhwang91/nvim-hlslens",
                after = {colorscheme, "nvim-hlslens"},
                event = "BufWinEnter",
                conf = "plugs.scrollbar",
            })

            -- use({"karb94/neoscroll.nvim", conf = "neoscroll", desc = "Smooth scrolling"})
            -- ]]] === Scrollbar ===

            -- ============================== Grepper ============================= [[[
            use({
                "mhinz/vim-grepper",
                cmd = {
                    "Grepper",
                    "GrepperRg",
                    "Grep",
                    "LGrep",
                    "GrepBuf",
                    "LGrepBuf",
                    "GrepBufs",
                    "LGrepBufs",
                },
                keys = {{"n", "gs"}, {"x", "gs"}, {"n", "<Leader>rg"}},
                conf = "grepper",
            })

            -- use({"nvim-pack/nvim-spectre"})
            -- ]]] === Grepper ===

            -- ============================ Trouble =============================== [[[
            use({
                "lmburns/trouble.nvim",
                requires = {{"kyazdani42/nvim-web-devicons", opt = true}},
                conf = "plugs.trouble",
                cmd = {"Trouble", "TroubleToggle"},
                keys = {
                    {"n", "]v"},
                    {"n", "[v"},
                    {"n", "]V"},
                    {"n", "[V"},
                    {"n", "<Leader>xx"},
                    {"n", "<Leader>xd"},
                    {"n", "<Leader>xR"},
                    {"n", "<Leader>xr"},
                    {"n", "<Leader>xy"},
                    {"n", "<Leader>xi"},
                    {"n", "<Leader>x;"},
                    {"n", "<Leader>x,"},
                    {"n", "<Leader>xk"},
                },
            })
            -- ]]] === Trouble ===

            -- =========================== Statusline ============================= [[[

            use({
                "b0o/incline.nvim",
                conf = "plugs.incline",
                event = "UIEnter",
            })

            use({
                "nvim-lualine/lualine.nvim",
                after = {colorscheme, "noice.nvim"},
                requires = {{"kyazdani42/nvim-web-devicons", opt = true}},
                conf = "plugs.lualine",
                event = "UIEnter",
            })

            use({
                "lmburns/nvim-gps",
                requires = {"nvim-treesitter/nvim-treesitter"},
                after = "nvim-treesitter",
            })

            use({
                "akinsho/bufferline.nvim",
                after = {colorscheme, "lualine.nvim"},
                conf = "plugs.bufferline",
                requires = {"kazhala/close-buffers.nvim", module = "close_buffers"},
                -- requires = "famiu/bufdelete.nvim"
            })

            -- ]]] === Statusline ===

            -- =========================== Indentline ============================= [[[
            use({
                "lukas-reineke/indent-blankline.nvim",
                conf = "plugs.indent_blankline",
                event = "UIEnter",
            })
            -- ]]] === Indentline ===

            use({
                "folke/noice.nvim",
                conf = "plugs.noice",
                wants = {"nui.nvim", "nvim-notify"},
                requires = {
                    {"MunifTanjim/nui.nvim", module = "nui"},
                    "rcarriga/nvim-notify",
                },
                event = {"UIEnter"},
            })

            -- use({"nullchilly/fsread.nvim", conf = "fsread", cmd = {"FSRead"}})

            -- =============================== Fzf ================================ [[[
            use({
                "junegunn/fzf.vim",
                requires = {{"junegunn/fzf", run = "./install --bin", frozen = true}},
                conf = "plugs.fzf",
            })

            use({
                "ibhagwan/fzf-lua",
                requires = {"kyazdani42/nvim-web-devicons"},
                conf = "plugs.fzf-lua",
            })
            -- ]]] === Fzf ===

            -- ============================= Operator ============================== [[[
            use({
                "phaazon/hop.nvim",
                conf = "plugs.hop",
                keys = {
                    {"n", "f"},
                    {"x", "f"},
                    {"o", "f"},
                    {"n", "F"},
                    {"x", "F"},
                    {"o", "F"},
                    {"n", "t"},
                    {"x", "t"},
                    {"o", "t"},
                    {"n", "T"},
                    {"x", "T"},
                    {"o", "T"},
                    {"n", "<Leader><Leader>j"},
                    {"n", "<Leader><Leader>k"},
                    {"n", "<Leader><Leader>J"},
                    {"n", "<Leader><Leader>K"},
                    {"n", "g("},
                    {"n", "g)"},
                    {"n", "g{"},
                    {"n", "g}"},
                    {"n", ";a"},
                    {"n", "s/"},
                    {"n", "sy"},
                    {"n", "s?"},
                    -- {"n", "<C-S-i>"},
                    -- {"n", "<C-S-o>"},
                    {"o", ","},
                    {"n", "<C-S-<>"},
                    {"n", "<C-S-:>"},    -- for nvim-treehopper
                    {"n", "<Leader>sH"}, -- for nvim-treehopper
                    {"n", "<Leader>sL"}, -- for nvim-treehopper
                },
            })
            use({
                "mfussenegger/nvim-treehopper",
                desc = "Region selection with hints on AST nodes",
                wants = "nvim-treesitter",
                after = "hop.nvim",
                requires = {"nvim-treesitter/nvim-treesitter", "phaazon/hop.nvim"},
            })

            use({
                "gbprod/substitute.nvim",
                conf = "plugs.substitute",
                -- keys = {
                --     {"n", "s"},
                --     {"n", "ss"},
                --     {"n", "se"},
                --     {"n", "sr"},
                --     {"n", "s;"},
                --     {"n", "<Leader>sr"},
                --     {"n", "sS"},
                --     {"n", "sx"},
                --     {"n", "sxx"},
                --     {"n", "sxc"},
                --     {"x", "s"},
                --     {"x", "X"}
                -- }
            })

            use({"machakann/vim-sandwich", conf = "plugs.textobj.sandwich"})
            use({"wellle/targets.vim", conf = "plugs.textobj.targets"})
            use({"wellle/line-targets.vim", requires = "wellle/targets.vim"})
            use({"andymass/vim-matchup", conf = "matchup", after = "nvim-treesitter"})
            use({
                "kana/vim-textobj-lastpat",
                requires = "kana/vim-textobj-user",
                keys = {
                    {"o", "i/"}, {"x", "i/"},
                    {"o", "a/"}, {"x", "a/"},
                },
            })
            use({
                "glts/vim-textobj-comment",
                requires = "kana/vim-textobj-user",
                setup = [[vim.g.loaded_textobj_comment = 1]],
                conf = "plugs.textobj.comment",
                keys = {
                    {"o", "iC"}, {"x", "iC"},
                    {"o", "aC"}, {"x", "aC"},
                    {"o", "aM"}, {"x", "aM"},
                },
            })
            -- use({"kana/vim-niceblock", keys = {{"x", "I"}, {"x", "A"}, {"x", "gI"}}})
            use({"kevinhwang91/nvim-ufo", requires = "kevinhwang91/promise-async"})

            use({
                "windwp/nvim-autopairs",
                wants = "nvim-treesitter",
                conf = "plugs.autopairs",
                -- event = "InsertEnter",
            })

            use({
                "sQVe/sort.nvim",
                conf = "sort",
                cmd = {"Sort"},
                keys = {{"n", "gz"}, {"x", "gz"}},
            })

            use({
                "monaqa/dial.nvim",
                conf = "plugs.dial",
                keys = {
                    {"n", "+"},
                    {"n", "_"},
                    {"v", "+"},
                    {"v", "_"},
                    {"v", "g+"},
                    {"v", "g_"},
                    {"n", "s-"},
                    {"n", "s="},
                    {"n", "s["},
                    {"n", "s]"},
                    {"n", "s`"},
                    {"n", "s~"},
                },
            })
            -- ]]] === Operator ===

            -- =============================== Tags =============================== [[[
            use({"ludovicchabant/vim-gutentags", conf = "plugs.gutentags"})
            use({"liuchengxu/vista.vim", after = "vim-gutentags", conf = "plugs.vista"})
            -- ]]] === Tags ===

            -- ============================= UndoTree ============================= [[[
            use({
                "mbbill/undotree",
                conf = "plugs.undotree",
                cmd = "UndoTreeToggle",
                keys = {{"n", "<Leader>ut"}},
            })

            use({
                "kevinhwang91/nvim-fundo",
                requires = "kevinhwang91/promise-async",
                conf = "fundo",
                -- run = [[require("fundo").install()]]
                run = function()
                    require("fundo").install()
                end,
            })
            -- ]]] === UndoTree ===

            -- ============================ Commenter ============================= [[[
            use({
                "numToStr/Comment.nvim",
                conf = "plugs.comment",
                after = "nvim-treesitter",
                requires = "nvim-treesitter/nvim-treesitter",
            })
            use({
                "LudoPinelli/comment-box.nvim",
                conf = "plugs.comment.comment_box",
                keys = {
                    {"n", "<Leader>bb"},
                    {"n", "<Leader>bs"},
                    {"n", "<Leader>bd"},
                    {"n", "<Leader>blc"},
                    {"n", "<Leader>bll"},
                    {"n", "<Leader>blr"},
                    {"n", "<Leader>br"},
                    {"n", "<Leader>bR"},
                    {"n", "<Leader>bc"},
                    {"n", "<Leader>ba"},
                    {"n", "<Leader>be"},
                    {"n", "<Leader>bA"},
                    {"n", "<Leader>cc"},
                    {"n", "<Leader>cb"},
                    {"n", "<Leader>ce"},
                    {"n", "<Leader>ca"},
                    {"n", "<Leader>cn"},
                    {"n", "<Leader>ct"},
                    {"n", "<Leader>cT"},
                    {"i", "<M-w>"},
                    {"i", "<C-M-w>"},
                    {"i", "<M-S-w>"},
                },
            })
            -- ]]] === Commenter ===

            -- =============================== Python ============================== [[[
            -- use({"jpalardy/vim-slime", ft = "python", conf = "slime"})
            -- ]]] === Python ===

            -- ============================= Javascript ============================ [[[
            -- use({"editorconfig/editorconfig-vim", conf = "plugs.editorconf"})
            use({
                "axelvc/template-string.nvim",
                conf = "plugs.ecma.template_string",
                requires = "nvim-treesitter/nvim-treesitter",
                ft = {"typescript", "typescriptreact", "javascript"},
            })
            -- use({
            --     "bennypowers/template-literal-comments.nvim",
            --     requires = "nvim-treesitter/nvim-treesitter",
            --     ft = {"typescript", "typescriptreact", "javascript"},
            -- })
            use({
                "vuki656/package-info.nvim",
                conf = "plugs.ecma.package_info",
                requires = {"MunifTanjim/nui.nvim", module = "nui"},
                event = "BufRead {package.json,*.ts,*.tsx,*.js,*.jsx}",
            })
            -- ]]] === Javascript ===

            -- ============================== Markdown ============================= [[[
            use({
                "dhruvasagar/vim-table-mode",
                conf = "plugs.markdown.table_mode",
                ft = {"markdown", "vimwiki"},
                -- cmds = {
                --     "Tableize",
                --     "TableSort",
                --     "TableModeEnable",
                --     "TableModeToggle",
                --     "TableModeDisable",
                --     "TableAddFormula",
                --     "TableEvalFormulaLine",
                -- },
                -- keys = {
                --     {"n", "<LocalLeader>H"},
                --     {"n", "<LocalLeader>L"},
                --     {"n", "<LocalLeader>K"},
                --     {"n", "<LocalLeader>J"},
                --     {"n", "<Leader>tm"},
                --     {"n", "<Leader>tS"},
                --     {"n", "<Leader>tt"},
                --     {"n", "<Leader>tr"},
                --     {"n", "<Leader>t?"},
                --     {"n", "<Leader>tdd"},
                --     {"n", "<Leader>tdc"},
                --     {"n", "<Leader>tiC"},
                --     {"n", "<Leader>tic"},
                --     {"n", "<Leader>tfa"},
                --     {"n", "<Leader>tfe"},
                --     {"n", "<Leader>ts"},
                --     {"x", "<Leader>ts"},
                --     {"x", "<Leader>tt"},
                --     {"x", "<Leader>T"},
                --     {"x", "ax"},
                --     {"x", "ix"},
                --     {"o", "ax"},
                --     {"o", "ix"},
                -- },
            })
            use({
                "SidOfc/mkdx",
                config = [[vim.cmd("source ~/.config/nvim/vimscript/plugins/mkdx.vim")]],
                -- ft = {"markdown", "vimwiki"},
            })

            use({
                "vimwiki/vimwiki",
                -- After this commit `\` or **\** are no longer highlighted
                commit = "63af6e72",
                setup = [[require("plugs.markdown").vimwiki_setup()]],
                ft = {"markdown", "vimwiki"},
                conf = "plugs.markdown.vimwiki",
                after = colorscheme,
            })

            use({
                "FraserLee/ScratchPad",
                conf = "scratchpad",
                keys = {{"n", "<Leader>sc"}},
                cmd = "ScratchPad",
            })
            -- ]]] === Markdown ===

            -- ================================ Wilder ============================= [[[
            use({
                "gelguy/wilder.nvim",
                run = ":UpdateRemotePlugins",
                event = {"CmdlineEnter"},
                fn = {"wilder#*"},
                requires = "romgrk/fzy-lua-native",
                conf = "plugs.wilder.init",
                setup = [[require('plugs.wilder').autocmd()]],
            })
            -- ]]] === Wilder ===

            -- ========================= Syntax-Highlighting ======================= [[[
            use({"sheerun/vim-polyglot", setup = [[require('plugs.polyglot')]]})

            -- use({"wfxr/dockerfile.vim"})
            -- use({"thesis/vim-solidity"})
            -- use({"tmux-plugins/vim-tmux", event = "BufRead tmux.conf"})
            use({"rhysd/vim-rustpeg", ft = "rustpeg"})
            use({"nastevens/vim-cargo-make"})
            use({"NoahTheDuke/vim-just", ft = "just"})
            use({"camnw/lf-vim", ft = "lf"})
            use({"ron-rs/ron.vim", ft = "ron"})
            -- ]]] === Syntax-Highlighting ===

            -- ============================= File-Viewer =========================== [[[
            use({"jamessan/vim-gnupg", event = "BufRead {*.asc,*.gpg}"})
            use({
                "mattn/vim-xxdcursor",
                event = "BufRead {*.o,*.so,*.a,*.out,*.bin,*.exe}",
            })
            use({
                "fidian/hexmode",
                config = [[vim.g.hexmode_patterns = '*.o,*.so,*.a,*.out,*.bin,*.exe']],
                event = "BufRead {*.o,*.so,*.a,*.out,*.bin,*.exe}",
            })
            -- use({
            --     "https://gitlab.com/itaranto/id3.nvim",
            --     tag = "*",
            --     config = function()
            --         require("id3").setup(
            --             {
            --                 mp3_tool = "id3",
            --                 flac_tool = "metaflac",
            --             }
            --         )
            --     end,
            -- })
            -- ]]] === File Viewer ===

            -- ============================== Snippets ============================= [[[
            use({"SirVer/ultisnips", conf = "ultisnips"})
            use({"honza/vim-snippets"})
            -- ]]] === Snippets ===

            -- ============================= Highlight ============================ [[[
            use({
                "NvChad/nvim-colorizer.lua",
                conf = "colorizer",
                ft = {
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
            })

            use({
                "folke/todo-comments.nvim",
                conf = "plugs.todo-comments",
                wants = "plenary.nvim",
                after = "telescope.nvim",
            })

            use({
                "folke/paint.nvim",
                event = "BufReadPre",
                conf = "plugs.paint",
            })

            use({
                "KabbAmine/vCoolor.vim",
                keys = {
                    {"n", "<Leader>pc"},
                    {"n", "<Leader>yb"},
                    {"n", "<Leader>yr"},
                },
                setup = [[vim.g.vcoolor_disable_mappings = 1 vim.g.vcoolor_lowercase = 1]],
                conf = "vcoolor",
            })

            -- ]]] === Highlight ===

            -- ============================= Neoformat ============================= [[[
            use({"sbdchd/neoformat", conf = "plugs.format"})
            -- ]]] === Neoformat ===

            -- ╭──────────────────────────────────────────────────────────╮
            -- │                           Coc                            │
            -- ╰──────────────────────────────────────────────────────────╯

            use({"Saecki/crates.nvim", event = "BufReadPre Cargo.toml", conf = "plugs.rust.crates"})

            use({"rust-lang/rust.vim", ft = "rust", conf = "plugs.rust"})
            -- use({'ThePrimeagen/refactoring.nvim', opt = true})
            -- use({"rescript-lang/vim-rescript"})
            -- use({"vim-crystal/vim-crystal", ft = "crystal"})

            -- use({"jalvesaq/Nvim-R", ft = {"r"}, branch = "stable", conf = "plugs.nvim-r"})
            use({"lervag/vimtex", conf = "plugs.vimtex", ft = {"tex", "latex"}})
            use({"fatih/vim-go", ft = "go", conf = "plugs.go"})
            use({"jlcrochet/vim-crystal", ft = "crystal"})
            use({"vim-perl/vim-perl", ft = "perl"})
            use({"m-pilia/vim-ccls", ft = {"cpp", "c"}, conf = "ccls"})
            use({"teal-language/vim-teal", ft = "teal"})
            use({"ziglang/zig.vim", ft = "zig", config = [[vim.g.zig_fmt_autosave = 0]]})

            use({
                "neoclide/coc.nvim",
                branch = "master",
                run = "yarn install --frozen-lockfile",
                requires = {
                    {"antoinemadec/coc-fzf", after = "coc.nvim"},
                    {
                        prefer_local("coc-code-action-menu"),
                        after = "coc.nvim",
                        -- keys = {
                        --     {"n", "<C-CR>"},
                        --     {"n", "<C-A-CR>"},
                        --     {"n", "<A-CR>"},
                        --     {"x", "<A-CR>"},
                        -- },
                    },
                    -- {"xiyaowong/coc-wxy", after = "coc.nvim", run = "yarn install --frozen-lockfile"},
                    {"kevinhwang91/coc-kvs", after = "coc.nvim", run = "yarn install"},
                    {
                        "yaegassy/coc-graphql",
                        after = "coc.nvim",
                        run = "yarn install --frozen-lockfile",
                    },
                    -- {'tjdevries/coc-zsh', after = "coc.nvim", ft = "zsh"},
                    -- {"yaegassy/coc-ast-grep", after = "coc.nvim", run = "yarn install --frozen-lockfile"},
                },
            })

            -- ╭──────────────────────────────────────────────────────────╮
            -- │                        Treesitter                        │
            -- ╰──────────────────────────────────────────────────────────╯

            use({"chrisgrieser/nvim-various-textobjs", conf = "plugs.textobj.various_textobjs"})
            -- use({
            --     "machakann/vim-swap",
            --     setup = [[vim.g.swap_no_default_key_mappings = 1]],
            --     conf = "plugs.treesitter.setup_swap",
            --     -- ft = {"zsh"}
            -- })
            use({
                "mizlan/iswap.nvim",
                conf = "plugs.treesitter.setup_iswap",
                after = "nvim-treesitter",
                keys = {
                    {"n", "vs"},
                    {"n", "sv"},
                    {"n", "so"},
                    {"n", "sc"},
                    {"n", "sh"},
                    {"n", "sl"},
                    {"n", "s,"},
                    {"n", "s."},
                },
                requires = {"nvim-treesitter/nvim-treesitter"},
            })
            -- use({
            --     "cshuaimin/ssr.nvim",
            --     conf = "plugs.treesitter.setup_ssr",
            --     requires = "nvim-treesitter/nvim-treesitter",
            --     after = "nvim-treesitter",
            --     keys = {{"n", "<Leader>s;"}},
            -- })

            -- aarondiel/spread.nvim
            -- use({
            --     "AndrewRadev/splitjoin.vim",
            --     conf = "plugs.treesitter.setup_splitjoin",
            -- })
            use({
                "Wansmer/treesj",
                conf = "plugs.treesitter.setup_treesj",
                keys = {
                    {"n", "gJ"},
                    {"n", "gK"},
                    {"n", [[g\]]},
                },
                requires = {"nvim-treesitter/nvim-treesitter"},
                -- after = "nvim-treesitter"
            })
            use({
                "nvim-treesitter/nvim-treesitter",
                run = ":TSUpdate",
                requires = {
                    {"nvim-treesitter/nvim-tree-docs"},
                    {
                        "nvim-treesitter/nvim-treesitter-refactor",
                        desc = "Refactor module",
                        patch = true,
                        after = "nvim-treesitter",
                    },
                    {
                        "RRethy/nvim-treesitter-endwise",
                        desc = "Adds 'end' to ruby and lua",
                        -- event = "InsertEnter",
                        -- after = "nvim-treesitter",
                    },
                    {
                        "nvim-treesitter/nvim-treesitter-textobjects",
                        after = "nvim-treesitter",
                    },
                    {
                        "nvim-treesitter/playground",
                        -- cmd = {"TSPlaygroundToggle"},
                        -- keys = {"n", "<Leader>sd"},
                    },
                    {
                        "windwp/nvim-ts-autotag",
                        desc = "Html/CSS/JSX tagging",
                        -- after = "nvim-treesitter",
                        ft = {
                            "html",
                            "xml",
                            "xhtml",
                            "phtml",
                            "javascript",
                            "typescript",
                            "javascriptreact",
                            "typescriptreact",
                            "svelte",
                            "vue",
                        },
                    },
                    {
                        "haringsrob/nvim_context_vt",
                        desc = "Adds -> context messages",
                        after = "nvim-treesitter",
                    },
                    {
                        "JoosepAlviste/nvim-ts-context-commentstring",
                        desc = "Embedded language comment strings",
                        after = "nvim-treesitter",
                    },
                    {
                        "David-Kunz/treesitter-unit",
                        desc = "Adds unit text object",
                        after = "nvim-treesitter",
                    },
                    {
                        "m-demare/hlargs.nvim",
                        -- "lmburns/hlargs.nvim",
                        desc = "Highlight argument definitions",
                        after = "nvim-treesitter",
                    },
                    {
                        "stevearc/aerial.nvim",
                        requires = "nvim-treesitter/nvim-treesitter",
                    },
                    {
                        "danymat/neogen",
                        desc = "Code documentation generator",
                        conf = "plugs.neogen",
                        after = "nvim-treesitter",
                        cmd = "Neogen",
                        keys = {
                            {"n", "<Leader>dg"},
                            {"n", "<Leader>dn"},
                            {"n", "<Leader>df"},
                            {"n", "<Leader>dc"},
                            {"n", "<Leader>dF"},
                        },
                    },
                    {
                        "mrjones2014/nvim-ts-rainbow",
                        -- "HiPhish/nvim-ts-rainbow2",
                        desc = "Rainbow parenthesis using treesitter",
                        after = "nvim-treesitter",
                    },
                    {
                        "ziontee113/syntax-tree-surfer",
                        desc = "Surf through your document and move elements around",
                        after = "nvim-treesitter",
                        conf = "plugs.treesitter.setup_treesurfer",
                        keys = {
                            {"n", "<C-M-,>"},
                            {"n", "<C-M-[>"},
                            {"n", "<C-M-]>"},
                            {"n", "<M-S-y>"},
                            {"n", "<M-S-u>"},
                            {"n", "("},
                            {"n", ")"},
                            {"n", "vu"},
                            {"n", "vd"},
                            {"n", "su"},
                            {"n", "sd"},
                            {"n", "vU"},
                            {"n", "vD"},
                            {"n", "vn"},
                            {"n", "vm"},
                            {"n", "v;"},
                            {"x", "<A-]>"},
                            {"x", "<A-[>"},
                            {"x", "<C-A-]>"},
                            {"x", "<C-A-[>"},
                            {"x", "<C-k>"},
                            {"x", "<C-j>"},
                        },
                        cmd = {
                            "STSSwapNextVisual",
                            "STSSwapPrevVisual",
                            "STSSelectChildNode",
                            "STSSelectParentNode",
                            "STSSelectPrevSiblingNode",
                            "STSSelectNextSiblingNode",
                            "STSSelectCurrentNode",
                            "STSSelectMasterNode",
                            "STSJumpToTop",
                        },
                    },
                    {
                        "ziontee113/query-secretary",
                        desc = "Help create treesitter queries",
                        after = "nvim-treesitter",
                        conf = "plugs.treesitter.setup_query_secretary",
                        keys = {{"n", "<Leader>qu"}},
                    },
                    -- {
                    --     "vigoux/architext.nvim",
                    --     desc = "Create treesitter queries",
                    --     -- cmd = {"Architext", "ArchitextREPL"},
                    --     after = "nvim-treesitter",
                    -- },
                },
            })

            -- {
            --     "nvim-treesitter/nvim-treesitter-context",
            --     desc = "Ability to see current context on top line",
            --     after = "nvim-treesitter"
            -- },

            -- ╭──────────────────────────────────────────────────────────╮
            -- │                        Telescope                         │
            -- ╰──────────────────────────────────────────────────────────╯

            use({
                "nvim-telescope/telescope.nvim",
                opt = false,
                conf = "plugs.telescope",
                after = {"popup.nvim", "plenary.nvim", colorscheme},
                requires = {
                    {
                        "nvim-telescope/telescope-ghq.nvim",
                        after = "telescope.nvim",
                        config = [[require("telescope").load_extension("ghq")]],
                    },
                    {
                        "nvim-telescope/telescope-github.nvim",
                        after = "telescope.nvim",
                        config = [[require("telescope").load_extension("gh")]],
                    },
                    {
                        "nvim-telescope/telescope-frecency.nvim",
                        after = "telescope.nvim",
                        requires = "tami5/sqlite.lua",
                        config = [[require("telescope").load_extension("frecency")]],
                    },
                    {
                        "fannheyward/telescope-coc.nvim",
                        after = "telescope.nvim",
                        config = [[require("telescope").load_extension("coc")]],
                    },
                    {
                        "fhill2/telescope-ultisnips.nvim",
                        after = "telescope.nvim",
                        config = [[require("telescope").load_extension("ultisnips")]],
                    },
                    {
                        "nvim-telescope/telescope-fzf-native.nvim",
                        after = "telescope.nvim",
                        run = "make",
                        config = [[require("telescope").load_extension("fzf")]],
                    },
                    {
                        "dhruvmanila/telescope-bookmarks.nvim",
                        after = "telescope.nvim",
                        config = [[require("telescope").load_extension("bookmarks")]],
                    },
                    {
                        "nvim-telescope/telescope-file-browser.nvim",
                        after = "telescope.nvim",
                        config = [[require("telescope").load_extension("file_browser")]],
                    },
                    {
                        "nvim-telescope/telescope-hop.nvim",
                        after = "telescope.nvim",
                        config = [[require("telescope").load_extension("hop")]],
                    },
                    {
                        "crispgm/telescope-heading.nvim",
                        after = "telescope.nvim",
                        config = [[require("telescope").load_extension("heading")]],
                    },
                    {
                        "nvim-telescope/telescope-smart-history.nvim",
                        requires = {"tami5/sqlite.lua"},
                        after = {"telescope.nvim", "sqlite.lua"},
                        config = [[require("telescope").load_extension("smart_history")]],
                        run = function()
                            local path = Path:new(Rc.dirs.data .. "/databases/")
                            if not path:exists() then
                                path:mkdir()
                            end
                        end,
                    },
                    {
                        "jvgrootveld/telescope-zoxide",
                        after = "telescope.nvim",
                        requires = "nvim-telescope/telescope.nvim",
                        config = [[require("telescope").load_extension("zoxide")]],
                    },
                    {
                        prefer_local("telescope-rualdi.nvim"),
                        after = "telescope.nvim",
                        config = [[require("telescope").load_extension("rualdi")]],
                    },
                },
            })

            -- use({
            --     "ecthelionvi/NeoComposer.nvim",
            --     requires = {"nvim-telescope/telescope.nvim", "tami5/sqlite.lua"},
            --     after = {"telescope.nvim", "sqlite.lua"},
            -- })
            use({
                "AckslD/nvim-neoclip.lua",
                requires = {"nvim-telescope/telescope.nvim", "tami5/sqlite.lua"},
                after = {"telescope.nvim", "sqlite.lua"},
                -- conf = "plugs.neoclip"
            })
            -- use({
            --     "gbprod/yanky.nvim",
            --     requires = {"nvim-telescope/telescope.nvim", "tami5/sqlite.lua"},
            --     after = {"telescope.nvim", "sqlite.lua", "nvim-neoclip.lua"},
            -- })

            -- ╭──────────────────────────────────────────────────────────╮
            -- │                           Git                            │
            -- ╰──────────────────────────────────────────────────────────╯
            use({
                "tpope/vim-fugitive",
                conf = "plugs.fugitive",
                fn = {"fugitive#*", "Fugitive*"},
                event = "BufReadPre */.git/index",
                cmd = {
                    "0Git",
                    "G",
                    "GBrowse",
                    "Gcd",
                    "Gclog",
                    "GDelete",
                    "Gdiffsplit",
                    "Gedit",
                    "Ggrep",
                    "Ghdiffsplit",
                    "Git",
                    "Glcd",
                    "Glgrep",
                    "Gllog",
                    "GMove",
                    "Gpedit",
                    "Gread",
                    "GRemove",
                    "GRename",
                    "Gsplit",
                    "Gtabedit",
                    "GUnlink",
                    "Gvdiffsplit",
                    "Gvsplit",
                    "Gwq",
                    "Gwrite",
                },
                keys = {
                    {"n", "<LocalLeader>gg"},
                    {"n", "<LocalLeader>gG"},
                    {"n", "<LocalLeader>ge"},
                    {"n", "<LocalLeader>gR"},
                    {"n", "<LocalLeader>gB"},
                    {"n", "<LocalLeader>gw"},
                    {"n", "<LocalLeader>gW"},
                    {"n", "<LocalLeader>gr"},
                    {"n", "<LocalLeader>gf"},
                    {"n", "<LocalLeader>gF"},
                    {"n", "<LocalLeader>gs"},
                    {"n", "<LocalLeader>gn"},
                    {"n", "<LocalLeader>gc"},
                    {"n", "<LocalLeader>ga"},
                    {"n", "<LocalLeader>gT"},
                    -- {"n", "<LocalLeader>gt"},
                    {"n", "<LocalLeader>gp"},
                    {"n", "<LocalLeader>gh"},
                    {"x", "<LocalLeader>gh"},
                    {"n", "<LocalLeader>gH"},
                    {"n", "<LocalLeader>gl"},
                    {"n", "<LocalLeader>gL"},
                    {"n", "<LocalLeader>gz"},
                    {"n", "<LocalLeader>gZ"},
                },
                requires = {"tpope/vim-rhubarb"},
            })
            use({
                "rbong/vim-flog",
                conf = "plugs.flog",
                cmd = {"Flog", "Flogsplit"},
                keys = {
                    {"n", "<Leader>gl"},
                    {"n", "<Leader>gg"},
                    {"n", "<Leader>gi"},
                    {"n", "<Leader>yl"},
                    {"n", "<Leader>yL"},
                    {"n", "<Leader>yi"},
                    {"n", "<Leader>yI"},
                    {"x", "<Leader>gl"},
                    {"x", "<Leader>gL"},
                },
                wants = "vim-fugitive",
                requires = "tpope/vim-fugitive",
            })
            use({
                "ruanyl/vim-gh-line",
                setup = [[vim.g.gh_line_blame_map_default = 0]],
                conf = "plugs.git.ghline",
                keys = {
                    {"n", "<Leader>go"},
                    {"n", "<Leader>gL"},
                },
            })

            use({
                "ahmedkhalf/project.nvim",
                conf = "plugs.git.project",
                after = "telescope.nvim",
            })
            use({
                "akinsho/git-conflict.nvim",
                conf = "plugs.git.git_conflict",
            })
            -- use({
            --     "kdheepak/lazygit.nvim",
            --     conf = "plugs.git.lazygit",
            --     after = "telescope.nvim",
            -- })

            use({
                "lewis6991/gitsigns.nvim",
                conf = "plugs.gitsigns",
                requires = {"nvim-lua/plenary.nvim"},
                wants = "nvim-scrollbar",
            })
            use({
                "TimUntersberger/neogit",
                conf = "plugs.neogit",
                requires = {"nvim-lua/plenary.nvim"},
            })
            use({
                "sindrets/diffview.nvim",
                cmd = {
                    "DiffviewClose",
                    "DiffviewFileHistory",
                    "DiffviewFocusFiles",
                    "DiffviewLog",
                    "DiffviewOpen",
                    "DiffviewRefresh",
                    "DiffviewToggleFiles",
                },
                conf = "plugs.diffview",
                keys = {
                    {"n", "<Leader>g;"},
                    {"n", "<Leader>g."},
                    {"n", "<Leader>gh"},
                    {"n", "<LocalLeader>gd"},
                    {"x", "<LocalLeader>gd"},
                },
            })

            -- ╭──────────────────────────────────────────────────────────╮
            -- │                          Fennel                          │
            -- ╰──────────────────────────────────────────────────────────╯
            use({
                "rktjmp/paperplanes.nvim",
                requires = "rktjmp/hotpot.nvim",
                conf = "paperplanes",
                cmd = "PP",
            })

            -- use({
            --     ("%s/%s"):format(Rc.dirs.config, "lua/plugs/nvim-reload"),
            --     conf = "plugs.nvim-reload",
            --     opt = true
            -- })

            --  ╭──────────────────────────────────────────────────────────╮
            --  │                          Notify                          │
            --  ╰──────────────────────────────────────────────────────────╯

            use({
                "rcarriga/nvim-notify",
                conf = "plugs.notify",
                after = {colorscheme, "telescope.nvim"},
            })
            use({
                "simrat39/desktop-notify.nvim",
                setup = [[pcall(vim.cmd, 'delcommand Notifications')]],
                config =
                [[vim.cmd('command! Notifications :lua require("notify")._print_history()<CR>')]],
            })
        end,
    }
)

-- For LSP
-- folke/neoconf.nvim
-- williamboman/mason.nvim
-- nacro90/numb.nvim          - Peek at line
-- PatschD/zippy.nvim
-- kristijanhusak/line-notes.nvim
-- smjonas/live-command.nvim
-- smjonas/inc-rename.nvim
-- gorbit99/codewindow.nvim
-- DNLHC/glance.nvim
-- lewis6991/hover.nvim
--
-- Eandrju/cellular-automaton.nvim
-- tamton-aquib/zone.nvim
-- nvim-zh/colorful-winsep.nvim
--
-- ggandor/leap.nvim
-- ggandor/leap-ast.nvim
-- stevearc/three.nvim
-- andrewferrier/debugprint.nvim
-- ldelossa/gh.nvim

-- haya14busa/vim-edgemotion
-- Remich/vim-tmsu

-- use({
--     prefer_local("symbols-outline.nvim"),
--     -- cmd = {"SymbolsOutline", "SymbolsOutlineOpen"},
--     -- keys = {{"n", '<A-S-">'}},
--     -- setup = [[require('plugs.config').outline()]],
--     conf = "outline"
-- })
