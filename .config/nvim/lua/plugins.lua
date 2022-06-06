-- ==========================================================================
--   Author: Lucas Burns
--    Email: burnsac@me.com
--  Created: 2022-03-26 15:02
-- ==========================================================================
local fn = vim.fn
local uv = vim.loop

local install_path = fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
if not uv.fs_stat(install_path) then
    fn.system("git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end

local ex = nvim.ex

ex.packadd("packer.nvim")
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
end

packer.init(
    {
        compile_path = ("%s/plugin/packer_compiled.lua"):format(fn.stdpath("config")),
        snapshot_path = ("%s/snapshot/packer.nvim"):format(fn.stdpath("config")),
        -- snapshot_path = ("%s/snapshot/packer.nvim"):format(fn.stdpath("cache")),
        -- opt_default = false,
        auto_clean = true,
        auto_reload_compiled = true,
        autoremove = false,
        ensure_dependencies = true,
        compile_on_sync = true,
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
            keybindings = {prompt_revert = "R", diff = "D", retry = "r", quit = "q", toggle_info = "<CR>"},
            open_fn = function()
                return require("packer.util").float({border = "rounded"})
            end
        },
        log = {level = "debug"},
        profile = {enable = true}
    }
)

PATCH_DIR = ("%s/patches"):format(fn.stdpath("config"))

local handlers = {
    conf = function(plugins, plugin, value)
        if value:match("^plugs%.") then
            plugin.config = ([[require('%s')]]):format(value)
        else
            plugin.config = ([[require('plugs.config').%s()]]):format(value)
        end
    end,
    disable = function(_, plugin, _)
        plugin.disable = require("common.control")[plugin.short_name]
    end,
    patch = function(plugins, plugin, value)
        -- local await = require("packer.async").wait
        -- local async = require("packer.async").sync
        -- local plugin_utils = require("packer.plugin_utils")
        -- local run_hook = plugin_utils.post_update_hook

        vim.validate {
            value = {
                value,
                function(n)
                    return type(n) == "string" or type(n) == "boolean"
                end,
                ("%s: must be a string or boolean"):format(plugin.short_name)
            }
        }

        if type(value) == "string" then
            value = fn.expand(value)
        else
            value = ("%s/%s.patch"):format(PATCH_DIR, plugin.short_name)
        end

        plugin.run = function()
            if uv.fs_stat(value) then
                nvim.p(("Applying patch: %s"):format(plugin.short_name), "WarningMsg")
                ex.lcd(plugin.install_path)
                Job:new(
                    {
                        command = "patch",
                        args = {"-s", "-N", "-p1", "-i", value},
                        on_exit = function(_, ret)
                            if ret ~= 0 then
                                nvim.p(("Unable to apply patch to %s"):format(plugin.name), "ErrorMsg")
                            end
                        end
                    }
                ):start()
            else
                nvim.p("Patch file does not exist", "ErrorMsg")
            end
        end

        -- FIX: Get a post_update_hook to work
        -- await(
        -- run_hook(
        --     plugin,
        --     {
        --         task_update = function()
        --             -- Reset the repository after updating to apply the patch again
        --             local git = require("common.gittool").cmd
        --             git({"reset", "HEAD", "--hard"})
        --         end
        --     }
        -- )
        -- )
    end
}

---Specify a configuration in `common.config` or its own file
packer.set_handler("conf", handlers.conf)

---Specify the disable marker for each plugin
---Can be disabled easier in the `control.lua` file
packer.set_handler(1, handlers.disable)

---Apply a patch to the given plugin
packer.set_handler("patch", handlers.patch)

---Use a local plugin found on the filesystem
---@param url string link to repo
---@param path string path to repo
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
        function(use)
            -- Package manager
            use(
                {
                    "wbthomason/packer.nvim",
                    opt = true,
                    setup = function()
                        if g.loaded_visual_multi == 1 then
                            vim.schedule(
                                function()
                                    vim.fn["vm#plugs#permanent"]()
                                end
                            )
                        end
                    end
                }
            )

            -- Cache startup
            use({"lewis6991/impatient.nvim", rocks = "mpack"})

            -- Faster version of filetype.vim
            -- use({"nathom/filetype.nvim", conf = "plugs.filetype"})

            -- Have more than one configuration
            -- use({"NTBBloodbath/cheovim", config = [[require("cheovim").setup({})]]})

            -- ============================ Vim Library =========================== [[[
            use({"tpope/vim-repeat"})
            use({"ryanoasis/vim-devicons"})
            -- ]]] === Vim Library ===

            -- ============================ Lua Library =========================== [[[
            use({"nvim-lua/popup.nvim"})
            use({"nvim-lua/plenary.nvim"})
            -- Allows ex commands as functions
            -- vim.api.nvim_<func> => nvim.<func>
            use({"norcalli/nvim.lua"})
            use({"arsham/arshlib.nvim", requires = {"nvim-lua/plenary.nvim"}})
            use({"tami5/sqlite.lua"})
            use({"kyazdani42/nvim-web-devicons"})

            use({"stevearc/dressing.nvim", event = "BufWinEnter", conf = "plugs.dressing"})
            -- ]]] === Lua Library ===

            -- ========================== Fixes / Addons ========================== [[[
            use({"antoinemadec/FixCursorHold.nvim", opt = false})
            use({"max397574/better-escape.nvim", conf = "better_esc"})
            -- numToStr/Navigator.nvim
            use({"mrjones2014/smart-splits.nvim", conf = "smartsplits"})
            use({"fedepujol/move.nvim", conf = "move"})
            -- Prevent clipboard from being hijacked by snippets and such
            use({"kevinhwang91/nvim-hclipboard"})
            use({"gbprod/yanky.nvim"})
            use({"tversteeg/registers.nvim", conf = "registers"})
            -- use({"AckslD/nvim-anywise-reg.lua", conf = "anywise"})
            use({"AndrewRadev/bufferize.vim", cmd = "Bufferize"}) -- replace builtin pager
            use({"kevinhwang91/promise-async"})
            use({"inkarkat/vim-SpellCheck", requires = {"inkarkat/vim-ingo-library"}})
            use({"skywind3000/asyncrun.vim", cmd = "AsyncRun"})
            use(
                {
                    "vim-scripts/UnconditionalPaste",
                    patch = true,
                    keys = {
                        -- These have been removed from my patch
                        -- {"n", "g]]p"}, -- Messes up packer compiled; Paste linewise with more indent
                        -- {"n", "g]]P"},
                        -- {"n", "g>p"}, -- Paste lines with count times 'shiftwidth indent'
                        -- {"n", "g>P"},
                        -- {"n", "g#p"}, -- Paste linewise as commented text
                        -- {"n", "g#P"},
                        -- {"n", "gBp"}, -- Paste minimal fitting block
                        -- {"n", "gBP"},
                        -- {"n", "gqbp"}, -- Query for separator string, then paste minimal block
                        -- {"n", "gBP"},
                        -- {"n", "g,p"}, -- Paste charwise with each line delimited by ','
                        -- {"n", "g,P"},
                        -- {"n", "g,'p"}, -- Paste charwise with each line delimited by "'"
                        -- {"n", "g,'P"},
                        -- {"n", "gqp"}, -- Query for separator string, paste charwise
                        -- {"n", "gqP"}

                        {"n", "gcp"}, -- Paste charwise (newline and indent flattened)
                        {"n", "gcP"},
                        {"n", "glp"}, -- Paste linewise (even if not complete)
                        {"n", "glP"},
                        {"n", "gbp"}, -- Paste blockwise (multiple lines in place, push text to right)
                        {"n", "gbP"},
                        {"n", "gap"}, -- Paste linewise above (like glp but adjust indent) (MODIFIED)
                        {"n", "g]p"}, -- Paste linewise above (like glp but adjust indent)
                        {"n", "g]P"},
                        {"n", "g[p"}, -- Paste linewise below (like glp but adjust indent)
                        {"n", "g[P"},
                        {"n", "gsp"}, -- Paste with [count] spaces around lines
                        {"n", "gsP"}
                    }
                }
            )

            -- :Subvert/child{,ren}/adult{,s}/g
            use(
                {
                    "tpope/vim-abolish",
                    conf = "abolish",
                    cmd = {"Subvert", "Abolish"},
                    keys = {
                        {"n", "cr"}
                    }
                }
            )

            -- TODO: Get completions to work just as regular S does
            -- :E2v = (\d{1,3})(?=(\d\d\d)+($|\D))
            -- Match = :M/<Items\s+attr="media">.+?<\/Items>/Im
            -- Substitute = :'<,'>S/(\d{1,3})(?=(\d\d\d)+($|\D))/\1,/g
            -- Global = :G/^begin$/+1;/^end$/-1:S/\l+/\U&/g
            -- :V
            use(
                {
                    "othree/eregex.vim",
                    cmd = {"E2v", "S", "M"},
                    after = "vim-abolish",
                    setup = [[vim.g.eregex_default_enable = 0]],
                    keys = {{"n", "<Leader>/"}},
                    conf = "eregex",
                    desc = "Ruby/Perl style regex for Vim"
                }
            )

            use(
                {
                    "mg979/vim-visual-multi",
                    setup = [[vim.g.VM_leader = '<Space>']],
                    keys = {
                        {"n", "<C-n>"},
                        {"x", "<C-n>"},
                        {"n", [[<Leader>\]]},
                        {"n", "<Leader>A"},
                        {"x", "<Leader>A"},
                        {"n", "<M-S-i>"},
                        {"n", "<M-S-o>"},
                        {"n", "<C-Up>"},
                        {"n", "<C-Down>"},
                        {"n", "g/"}
                    },
                    cmd = {"VMSearch"},
                    conf = "visualmulti",
                    wants = {"nvim-hlslens", "nvim-autopairs"}
                }
            )
            -- ]]] === Fixes ===

            -- =========================== Colorscheme ============================ [[[
            local colorscheme = "kimbox"
            -- Needed for some themes
            use({"rktjmp/lush.nvim"})

            use({"eddyekofo94/gruvbox-flat.nvim"})
            use({"sainnhe/gruvbox-material"})
            use({"sainnhe/edge"})
            use({"sainnhe/everforest"})
            use({"sainnhe/sonokai"})
            use({"glepnir/oceanic-material"})
            use({"franbach/miramare"})
            use({"pineapplegiant/spaceduck"})
            -- Need to make a new theme for this
            use({"tyrannicaltoucan/vim-deep-space"})
            -- Need to make a new theme for this
            use({"ackyshake/Spacegray.vim"})
            use({"vv9k/bogster"})
            use({"cocopon/iceberg.vim"})
            use({"wadackel/vim-dogrun"})
            use({"savq/melange"})
            use({"folke/tokyonight.nvim"})
            use({"tiagovla/tokyodark.nvim"})
            use({"bluz71/vim-nightfly-guicolors"})
            use({"haishanh/night-owl.vim"})
            use({"rebelot/kanagawa.nvim"})
            use({"KeitaNakamura/neodark.vim"})
            use({"EdenEast/nightfox.nvim"})
            use({"catppuccin/nvim", as = "catppuccin"})
            use({"rose-pine/neovim", as = "rose-pine"})
            use({"marko-cerovac/material.nvim"})
            use({"ghifarit53/daycula-vim"})
            use({"rmehri01/onenord.nvim"})
            use({"levuaska/levuaska.nvim"})
            use({"kyazdani42/blue-moon"})
            -- Needs modified to change transparent background
            -- use({"Mofiqul/vscode.nvim"})
            -- use({"FrenzyExists/aquarium-vim"})
            -- use({"yashguptaz/calvera-dark.nvim"})
            -- use({"andersevenrud/nordic.nvim"})
            -- use({"aktersnurra/no-clown-fiesta.nvim"})
            -- use({"pwntester/nautilus.nvim"})
            -- use({"doums/darcula"})
            -- use({"ray-x/aurora"})
            -- use({"shaunsingh/nord.nvim"})
            -- use({"katawful/kat.nvim"})
            -- use({"daschw/leaf.nvim"})
            -- use({"Domeee/mosel.nvim"})
            -- use({"lewpoly/sherbet.nvim"})
            -- use({"projekt0n/github-nvim-theme"})
            -- use({"metalelf0/jellybeans-nvim", requires = "rktjmp/lush.nvim"})
            -- use({"kvrohit/substrata.nvim"})
            -- use({"numToStr/Sakura.nvim"})
            -- use({"fcpg/vim-farout"})
            -- use({"tyrannicaltoucan/vim-quantum"})
            -- use({"b4skyx/serenade"})
            -- use({"AlessandroYorba/Alduin"})
            -- use({ "olimorris/onedarkpro.nvim" })
            -- use({ "kaicataldo/material.vim" })

            use({"lmburns/kimbox", conf = "plugs.kimbox"})
            -- ]]] === Colorscheme ===

            -- ============================== WhichKey ============================ [[[
            use({"folke/which-key.nvim", conf = "plugs.which-key"})
            use(
                {
                    "mrjones2014/legendary.nvim",
                    conf = "plugs.legendary",
                    requires = {"stevearc/dressing.nvim", "folke/which-key.nvim"}
                }
            )
            -- ]]] === WhichKey ===

            -- ======================== Session Management ======================== [[[
            use(
                {
                    "folke/persistence.nvim",
                    event = "BufReadPre", -- this will only start session saving when an actual file was opened
                    module = "persistence",
                    conf = "persistence"
                }
            )

            -- rmagatti/auto-session
            -- use({"Shatur/neovim-session-manager", event = "BufReadPre", conf = "session_manager"})
            -- ]]] === Session ===

            -- ============================== Debugging ============================ [[[
            use(
                {
                    "mfussenegger/nvim-dap",
                    conf = "plugs.dap",
                    after = "telescope.nvim",
                    wants = "one-small-step-for-vimkind",
                    requires = {
                        {"jbyuki/one-small-step-for-vimkind"},
                        {"theHamsta/nvim-dap-virtual-text"},
                        {
                            "nvim-telescope/telescope-dap.nvim",
                            after = "nvim-dap",
                            config = [[require("telescope").load_extension("dap")]]
                        },
                        {
                            "rcarriga/nvim-dap-ui",
                            after = "nvim-dap",
                            config = function()
                                require("dapui").setup()
                            end
                        },
                        {
                            "mfussenegger/nvim-dap-python",
                            after = "nvim-dap",
                            wants = "nvim-dap",
                            config = function()
                                require("dap-python").setup(("%s/shims/python"):format(env.PYENV_ROOT))
                            end
                        }
                    }
                }
            )

            -- use({ "bfredl/nvim-luadev", conf = "luadev", ft = "lua" })
            use({"rafcamlet/nvim-luapad", cmd = {"Luapad", "LuaRun"}, ft = "lua"})

            -- Most docs are already available through coc.nvim
            use({"milisims/nvim-luaref", ft = "lua"})
            use({"nanotee/luv-vimdocs", ft = "lua"})
            use({"tjdevries/nlua.nvim", ft = "lua", conf = "nlua"})
            use({"max397574/lua-dev.nvim", ft = "lua", module = "lua-dev"})

            -- use(
            --     {
            --       "puremourning/vimspector",
            --       setup = [[vim.g.vimspector_enable_mappings = 'HUMAN']],
            --       disable = true,
            --     }
            -- )

            -- ]]] === Debugging ===

            -- ============================ File Manager =========================== [[[
            use({"kevinhwang91/rnvimr", opt = false, conf = "plugs.rnvimr"})
            use(
                {
                    prefer_local("lf.nvim"),
                    conf = "lfnvim",
                    requires = {
                        "plenary.nvim",
                        "toggleterm.nvim"
                    }
                }
            )
            -- use({"ptzz/lf.vim", conf = "lf"})

            -- ]]] === File Manager ===

            -- ============================ Neo/Floaterm =========================== [[[
            use({"voldikss/fzf-floaterm", requires = {"voldikss/vim-floaterm"}, conf = "floaterm"})

            use(
                {
                    "akinsho/toggleterm.nvim",
                    conf = "plugs.neoterm",
                    keys = {"gzo", "gzz", "<C-\\>"},
                    cmd = {"T", "TR", "TP", "VT"}
                }
            )
            -- use({ "kassio/neoterm", conf = "neoterm" })
            -- ]]] === Floaterm ===

            -- =========================== BetterQuickFix ========================== [[[
            -- romainl/vim-qf

            -- FIX: cclose won't work
            -- use({"stefandtw/quickfix-reflector.vim", ft = {"qf"}, conf = "qf_reflector"})
            -- use({"https://gitlab.com/yorickpeterse/nvim-pqf", config = [[require('pqf').setup()]]})

            use({"kevinhwang91/nvim-bqf", ft = {"qf"}, conf = "bqf"})
            use(
                {
                    "arsham/listish.nvim",
                    requires = {
                        "arsham/arshlib.nvim",
                        "norcalli/nvim.lua"
                    },
                    conf = "listish"
                }
            )
            -- ]]] === BetterQuickFix ===

            -- ============================ EasyAlign ============================= [[[
            use(
                {
                    "junegunn/vim-easy-align",
                    conf = "plugs.easy-align",
                    keys = {{"x", "ga"}, {"x", "<Leader>ga"}, {"x", "<Leader>gi"}, {"x", "<Leader>ga"}},
                    cmd = {"EasyAlign", "LiveEasyAlign"}
                }
            )
            -- ]]] === EasyAlign ===

            -- ============================ Open Browser =========================== [[[
            use({"tyru/open-browser.vim", conf = "open_browser"})
            use({"axieax/urlview.nvim", conf = "urlview", after = "telescope.nvim"})
            -- ]]] === Open Browser ===

            -- ============================ Limelight ============================= [[[
            use(
                {
                    "folke/zen-mode.nvim",
                    cmd = "ZenMode",
                    keys = {{"n", "<Leader>zm"}},
                    {
                        "folke/twilight.nvim",
                        conf = "plugs.twilight",
                        after = "zen-mode.nvim",
                        cmd = "Twilight",
                        keys = {{"n", "<Leader>li"}, {"n", "<Leader>zm"}}
                    }
                }
            )
            -- ]]] === Limelight ===

            -- ============================= Vimtex =============================== [[[
            use({"lervag/vimtex", conf = "plugs.vimtex"})
            -- ]]] === Vimtex ===

            use(
                {
                    "kevinhwang91/suda.vim",
                    keys = {{"n", "<Leader>W"}},
                    cmd = {"SudaRead", "SudaWrite"},
                    conf = "suda"
                }
            )

            -- ============================== VCooler ============================== [[[
            use(
                {
                    "KabbAmine/vCoolor.vim",
                    keys = {
                        {"n", "<Leader>pc"},
                        {"n", "<Leader>yb"},
                        {"n", "<Leader>yr"}
                    },
                    setup = [[vim.g.vcoolor_disable_mappings = 1 vim.g.vcoolor_lowercase = 1]],
                    conf = "vcoolor"
                }
            )
            -- ]]] === VCooler ===

            -- =============================== Marks ============================== [[[
            use({"chentoast/marks.nvim", conf = "plugs.marks"})
            -- ]]] === Marks ===

            -- ============================== HlsLens ============================= [[[
            use(
                {
                    "kevinhwang91/nvim-hlslens",
                    conf = "hlslens",
                    requires = "haya14busa/vim-asterisk",
                    keys = {
                        {"n", "n"},
                        {"x", "n"},
                        {"o", "n"},
                        {"n", "N"},
                        {"x", "N"},
                        {"o", "N"},
                        {"n", "/"},
                        {"n", "?"},
                        {"n", "*"},
                        {"x", "*"},
                        {"n", "#"},
                        {"x", "#"},
                        {"n", "g*"},
                        {"x", "g*"},
                        {"n", "g#"},
                        {"x", "g#"}
                    }
                }
            )
            -- ]]] === HlsLens ===

            -- ============================== Grepper ============================= [[[
            use(
                {
                    "mhinz/vim-grepper",
                    cmd = "Grepper",
                    keys = {{"n", "gs"}, {"x", "gs"}, {"n", "<Leader>rg"}},
                    conf = "grepper"
                }
            )

            -- use({"nvim-pack/nvim-spectre"})
            -- ]]] === Grepper ===

            -- ============================ Scrollbar ============================= [[[
            use(
                {
                    "petertriho/nvim-scrollbar",
                    requires = "kevinhwang91/nvim-hlslens",
                    after = colorscheme,
                    conf = "plugs.scrollbar"
                }
            )

            -- use({"karb94/neoscroll.nvim", conf = "neoscroll", desc = "Smooth scrolling"})

            use(
                {
                    "edluffy/specs.nvim",
                    -- after = "neoscroll.nvim",
                    conf = "specs",
                    desc = "Keep an eye on where the cursor moves"
                }
            )
            -- ]]] === Scrollbar ===

            -- ============================ Trouble =============================== [[[
            -- "folke/trouble.nvim",
            use(
                {
                    "lmburns/trouble.nvim",
                    requires = {"kyazdani42/nvim-web-devicons", opt = true},
                    conf = "plugs.trouble"
                }
            )
            -- ]]] === Trouble ===

            -- =========================== Statusline ============================= [[[

            -- use ({ 'b0o/incline.nvim', conf = "incline" })
            use(
                {
                    "nvim-lualine/lualine.nvim",
                    after = colorscheme,
                    requires = {"kyazdani42/nvim-web-devicons", opt = true},
                    conf = "plugs.lualine"
                }
            )

            use(
                {
                    "SmiteshP/nvim-gps",
                    requires = {"nvim-treesitter/nvim-treesitter"},
                    after = "nvim-treesitter",
                    config = [[require("nvim-gps").setup()]]
                }
            )

            use(
                {
                    "akinsho/bufferline.nvim",
                    after = {colorscheme, "lualine.nvim"},
                    conf = "plugs.bufferline",
                    requires = "famiu/bufdelete.nvim"
                }
            )
            -- ]]] === Lualine ===

            -- =========================== Indentline ============================= [[[
            use(
                {
                    "lukas-reineke/indent-blankline.nvim",
                    after = colorscheme,
                    conf = "plugs.indent_blankline"
                }
            )
            -- ]]] === Indentline ===

            -- =============================== Fzf ================================ [[[
            use(
                {
                    "junegunn/fzf.vim",
                    requires = {{"junegunn/fzf", run = "./install --bin"}},
                    conf = "plugs.fzf"
                }
            )

            use(
                {
                    "ibhagwan/fzf-lua",
                    requires = {"kyazdani42/nvim-web-devicons"},
                    conf = "plugs.fzf-lua"
                }
            )

            -- use({"vijaymarupudi/nvim-fzf"})
            -- use({ "lotabout/skim", run = "./install --bin" })
            -- ]]] === Fzf ===

            -- ====================== Window Picker ======================= [[[
            -- sindrets/winshift.nvim
            -- t9md/vim-choosewin
            use(
                {
                    "https://gitlab.com/yorickpeterse/nvim-window",
                    conf = "window_picker",
                    keys = {{"n", "<M-->"}}
                }
            )
            -- ]]] === Window Picker ===

            -- ============================= Operator ============================== [[[
            use(
                {
                    "AckslD/nvim-trevJ.lua",
                    conf = "trevj",
                    keys = {{"n", "gJ"}},
                    requires = "nvim-treesitter"
                }
            )

            -- use({"AndrewRadev/splitjoin.vim", keys = {{"n", "gJ"}, {"n", "gS"}}})

            use(
                {
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
                        {"n", "<Leader><Leader>h"},
                        {"n", "<Leader><Leader>j"},
                        {"n", "<Leader><Leader>k"},
                        {"n", "<Leader><Leader>l"},
                        {"n", "<Leader><Leader>J"},
                        {"n", "<Leader><Leader>K"},
                        {"n", "<Leader><Leader>/"},
                        {"n", "<Leader><Leader>o"},
                        {"n", "<C-S-:>"},
                        {"n", "<C-S-<>"}
                    }
                }
            )

            use(
                {
                    "gbprod/substitute.nvim",
                    conf = "plugs.substitute",
                    keys = {
                        {"n", "s"},
                        {"n", "ss"},
                        {"n", "se"},
                        {"n", "sr"},
                        {"n", "<Leader>sr"},
                        {"n", "sS"},
                        {"n", "sx"},
                        {"n", "sxx"},
                        {"n", "sxc"},
                        {"x", "s"},
                        {"x", "X"}
                    }
                }
            )

            -- ur4ltz/surround.nvim

            -- b = (), B = {}, r = [], a = <>
            -- use(
            --     {
            --         "tpope/vim-surround",
            --         setup = [[vim.g.surround_no_mappings = 1]],
            --         keys = {
            --             {"n", "ds"},
            --             {"n", "cs"},
            --             {"n", "cS"},
            --             {"n", "ys"},
            --             {"n", "ysW"},
            --             {"n", "yS"},
            --             {"n", "yss"},
            --             {"n", "ygs"},
            --             {"x", "S"},
            --             {"x", "gS"}
            --         },
            --         conf = "surround"
            --     }
            -- )

            use(
                {
                    "machakann/vim-sandwich",
                    conf = "sandwhich"
                    -- keys = {
                    --     {"n", "ds"},
                    --     {"n", "cs"},
                    --     {"n", "cS"},
                    --     {"n", "ys"},
                    --     {"n", "ysW"},
                    --     {"n", "yS"},
                    --     {"n", "yss"},
                    --     {"n", "ygs"},
                    --     {"x", "S"},
                    --     {"x", "gS"},
                    --     {"v", "sa"},
                    --     {"o", "is"},
                    --     {"o", "as"},
                    --     {"o", "ib"},
                    --     {"o", "ab"}
                    -- }
                }
            )

            -- use({ "lambdalisue/readablefold.vim", event = "VimEnter" })
            use(
                {
                    "pseewald/vim-anyfold",
                    cmd = "AnyFoldActivate",
                    setup = [[vim.g.anyfold_fold_display = 0]]
                }
            )

            use(
                {
                    "anuvyklack/pretty-fold.nvim",
                    requires = "anuvyklack/nvim-keymap-amend"
                }
            )

            use(
                {
                    "windwp/nvim-autopairs",
                    conf = "plugs.autopairs",
                    event = "InsertEnter"
                }
            )

            -- use(
            --     {
            --       "Raimondi/delimitMate",
            --       event = "InsertEnter",
            --       conf = "delimitmate",
            --     }
            -- )

            use(
                {
                    "monaqa/dial.nvim",
                    conf = "plugs.dial",
                    keys = {
                        {"n", "+"},
                        {"n", "_"},
                        {"v", "+"},
                        {"v", "_"},
                        {"v", "g+"},
                        {"v", "g_"}
                    }
                }
            )
            -- ]]] === Operator ===

            -- =============================== Tags =============================== [[[
            use({"ludovicchabant/vim-gutentags", conf = "plugs.gutentags"})
            use(
                {
                    "liuchengxu/vista.vim",
                    after = "vim-gutentags",
                    conf = "plugs.vista"
                }
            )
            -- ]]] === Tags ===

            -- ============================= UndoTree ============================= [[[
            use(
                {
                    "mbbill/undotree",
                    cmd = "UndoTreeToggle",
                    conf = "plugs.undotree",
                    keys = {{"n", "<Leader>ut"}}
                }
            )
            -- ]]] === UndoTree ===

            -- ========================== NerdCommenter =========================== [[[
            use({"numToStr/Comment.nvim", conf = "plugs.comment", after = "nvim-treesitter"})
            use({"LudoPinelli/comment-box.nvim", conf = "comment_box"})
            -- ]]] === UndoTree ===

            -- ============================== Targets ============================== [[[
            -- kana/vim-textobj-user
            use({"wellle/targets.vim", conf = "targets"})
            use({"andymass/vim-matchup", conf = "matchup"})
            -- ]]] === Targets ===

            -- ============================== Nvim-R =============================== [[[
            use({"jalvesaq/Nvim-R", branch = "stable", conf = "plugs.nvim-r"})
            -- ]]] === Nvim-R ===

            -- =============================== Python ============================== [[[
            use({"jpalardy/vim-slime", ft = "python", conf = "slime"})
            -- ]]] === Python ===

            -- ================================ Rust =============================== [[[
            use({"rust-lang/rust.vim", ft = "rust", conf = "plugs.rust"})

            use({"Saecki/crates.nvim", event = "BufRead Cargo.toml", conf = "crates"})
            -- use(
            --     {
            --       "simrat39/rust-tools.nvim",
            --       ft = "rust",
            --       config = function()
            --         require("rust-tools").setup {}
            --       end,
            --       requires = { "plenary.nvim", "nvim-lspconfig" },
            --     }
            -- )
            -- ]]] === VimSlime - Python ===

            -- ============================= Javascript ============================ [[[
            use(
                {
                    "vuki656/package-info.nvim",
                    requires = "MunifTanjim/nui.nvim",
                    conf = "package_info"
                }
            )

            use(
                {
                    "bennypowers/nvim-regexplainer",
                    requires = {
                        "nvim-lua/plenary.nvim",
                        "MunifTanjim/nui.nvim",
                        {"nvim-treesitter/nvim-treesitter", opt = true}
                    },
                    after = {"nvim-treesitter"},
                    conf = "regexplainer"
                }
            )
            -- ]]] === Javascript ===

            -- ============================== Vim - Go ============================= [[[
            use({"fatih/vim-go", ft = "go", conf = "plugs.go"})
            -- ]]] === VimSlime - Python ===

            -- ============================== Markdown ============================= [[[
            -- use(
            --     {
            --       "renerocksai/telekasten.nvim",
            --       after = { "telescope.nvim" },
            --       require = { "renerocksai/calendar-vim" },
            --       conf = "plugs.telekasten"
            --     }
            -- )

            -- use(
            --     {
            --         "lukas-reineke/headlines.nvim",
            --         config = function()
            --             require("headlines").setup()
            --         end
            --     }
            -- )

            -- use(
            --     {
            --         "vim-pandoc/vim-pandoc-syntax",
            --         ft = {"pandoc", "markdown", "vimwiki"},
            --         conf = "pandoc"
            --     }
            -- )

            use(
                {
                    "plasticboy/vim-markdown",
                    ft = {"markdown", "vimwiki"},
                    conf = "markdown"
                }
            )

            use(
                {
                    "dhruvasagar/vim-table-mode",
                    ft = {"markdown", "vimwiki"},
                    conf = "table_mode"
                }
            )

            -- FIX: TOC is written each time
            -- use(
            --     {
            --         "SidOfc/mkdx",
            --         ft = {"markdown", "vimwiki"},
            --         config = function()
            --             vim.cmd("source " .. fn.stdpath("config") .. "/vimscript/plugins/mkdx.vim")
            --         end
            --     }
            -- )

            use({"vimwiki/vimwiki", conf = "vimwiki", after = colorscheme})
            use({"FraserLee/ScratchPad", conf = "scratchpad"})
            -- ]]] === Markdown ===

            -- ================================ Wilder ============================= [[[
            use(
                {
                    "gelguy/wilder.nvim",
                    run = ":UpdateRemotePlugins",
                    -- rocks = "pcre2",
                    requires = "romgrk/fzy-lua-native",
                    conf = "plugs.wilder"
                }
            ) -- ]]] === Wilder ===

            -- ========================= Syntax-Highlighting ======================= [[[
            use(
                {
                    "sheerun/vim-polyglot",
                    setup = function()
                        g.polyglot_disabled = {
                            "ftdetect",
                            -- "sensible",
                            "markdown",
                            "rustpeg",
                            "lf",
                            "ron",
                            "cmake",
                            "css",
                            "cpp",
                            "d",
                            "dart",
                            "dockerfile",
                            "go",
                            "gomod",
                            "html",
                            "java",
                            -- "lua",
                            -- "json",
                            -- "kotlin",
                            -- "lua",
                            "make",
                            -- "perl",
                            "python",
                            "query",
                            "ruby",
                            "rust",
                            "scss",
                            "vim",
                            -- "teal",
                            -- "tsx",
                            -- "vue",
                            "zig"
                            -- "zsh"
                            -- "typescript",
                        }
                    end
                }
            )

            -- use({ "wfxr/dockerfile.vim" })
            use({"rhysd/vim-rustpeg", ft = "rustpeg"})
            use({"nastevens/vim-cargo-make"})
            use({"NoahTheDuke/vim-just", ft = "just"})
            use({"camnw/lf-vim", ft = "lf"})
            use({"ron-rs/ron.vim", ft = "ron"})
            -- ]]] === Syntax-Highlighting ===

            -- =========================== Keymaps - Nest ========================== [[[
            -- use({ "LionC/nest.nvim", conf = "plugs.keymaps" })
            -- ]]] === Keymaps ===

            -- ============================= File-Viewer =========================== [[[
            use({"mattn/vim-xxdcursor"})
            use(
                {
                    "fidian/hexmode",
                    config = [[vim.g.hexmode_patterns = '*.o,*.so,*.a,*.out,*.bin,*.exe']]
                }
            )

            use({"jamessan/vim-gnupg"})
            use({"AndrewRadev/id3.vim"})
            use({"alx741/vinfo"})
            use({"HiPhish/info.vim", conf = "info"})
            -- ]]] === File Viewer ===

            -- ============================== Snippets ============================= [[[
            use({"SirVer/ultisnips", conf = "ultisnips"})
            use({"honza/vim-snippets"})
            -- ]]] === Snippets ===

            -- ============================= Highlight ============================ [[[
            -- use({"rrethy/vim-hexokinase", run = "make hexokinase"})
            use({"chrisbra/Colorizer", cmd = {"Colorizer", "ColorHighlight"}})
            -- The following plugin really needs to support ansi sequences
            use(
                {
                    "norcalli/nvim-colorizer.lua",
                    cmd = "ColorizerToggle",
                    ft = {
                        "gitconfig",
                        "vim",
                        "sh",
                        "zsh",
                        "markdown",
                        "tmux",
                        "yaml",
                        "xml",
                        "css",
                        "typescript",
                        "javascript",
                        "lua"
                    },
                    conf = "colorizer"
                }
            )

            use(
                {
                    "Pocco81/HighStr.nvim",
                    event = "VimEnter",
                    conf = "plugs.HighStr"
                }
            )

            use(
                {
                    "folke/todo-comments.nvim",
                    conf = "plugs.todo-comments",
                    wants = "plenary.nvim",
                    after = "telescope.nvim"
                }
            )
            -- ]]] === Highlight ===

            -- ============================= Neoformat ============================= [[[
            use({"sbdchd/neoformat", conf = "plugs.neoformat"})
            -- ]]] === Neoformat ===

            -- =============================== Coc ================================ [[[
            -- use({ 'tjdevries/coc-zsh', ft = "zsh" })
            -- use({ 'ThePrimeagen/refactoring.nvim', opt = true })

            -- use({"vim-crystal/vim-crystal", ft = "crystal"})
            use({"jlcrochet/vim-crystal", ft = "crystal"})
            use({"vim-perl/vim-perl", ft = "perl"})
            use({"teal-language/vim-teal", ft = "teal"})
            use({"ziglang/zig.vim", ft = "zig", config = [[vim.g.zig_fmt_autosave = 0]]})

            use(
                {
                    "neoclide/coc.nvim",
                    branch = "master",
                    run = "yarn install --frozen-lockfile",
                    config = [[require('plugs.coc').tag_cmd()]],
                    requires = {
                        {"antoinemadec/coc-fzf", after = "coc.nvim"},
                        {"kevinhwang91/coc-kvs", after = "coc.nvim", run = "yarn install --frozen-lockfile"},
                        {"xiyaowong/coc-wxy", after = "coc.nvim", run = "yarn install --frozen-lockfile"},
                        {prefer_local("coc-code-action-menu"), after = "coc.nvim"}
                        -- TODO: Once the error of cursor is fixed
                    }
                }
            )
            -- ]]] === Coc ===

            -- ============================= Treesitter ============================ [[[
            -- use({ "vigoux/architext.nvim", after = { "nvim-treesitter" } })
            use({"mizlan/iswap.nvim", requires = "nvim-treesitter/nvim-treesitter", after = "nvim-treesitter"})
            use(
                {
                    -- conf = "plugs.treesitter"
                    "nvim-treesitter/nvim-treesitter",
                    run = ":TSUpdate",
                    requires = {
                        {
                            "nvim-treesitter/nvim-treesitter-refactor",
                            after = "nvim-treesitter",
                            desc = "Refactor module"
                        },
                        {
                            "RRethy/nvim-treesitter-endwise",
                            after = "nvim-treesitter",
                            desc = "Adds 'end' to ruby and lua"
                        },
                        {
                            "nvim-treesitter/nvim-treesitter-textobjects",
                            after = "nvim-treesitter"
                        },
                        {
                            "nvim-treesitter/playground",
                            after = "nvim-treesitter"
                            -- cmd = {"TSHighlightCapturesUnderCursor", "TSPlaygroundToggle"}
                        },
                        {
                            "windwp/nvim-ts-autotag",
                            after = "nvim-treesitter",
                            desc = "Html/Css tagging"
                        },
                        {
                            "JoosepAlviste/nvim-ts-context-commentstring",
                            after = "nvim-treesitter",
                            desc = "Embedded language comment strings"
                        },
                        {
                            "michaeljsmith/vim-indent-object",
                            after = "nvim-treesitter",
                            desc = "ai ii aI iI text objects"
                        },
                        {
                            "haringsrob/nvim_context_vt",
                            after = "nvim-treesitter",
                            desc = "Adds -> context messages"
                        },
                        {
                            "David-Kunz/treesitter-unit",
                            after = "nvim-treesitter",
                            desc = "Adds unit text object"
                        },
                        {
                            "m-demare/hlargs.nvim",
                            after = "nvim-treesitter",
                            desc = "Highlight argument definitions"
                        },
                        {
                            "stevearc/aerial.nvim",
                            after = "nvim-treesitter"
                        },
                        {
                            "danymat/neogen",
                            conf = "neogen",
                            after = "nvim-treesitter",
                            keys = {
                                {"n", "<Leader>dg"},
                                {"n", "<Leader>df"},
                                {"n", "<Leader>dc"}
                            }
                        },
                        {
                            "lewis6991/spellsitter.nvim",
                            after = "nvim-treesitter",
                            config = [[require("spellsitter").setup()]]
                        },
                        {
                            "p00f/nvim-ts-rainbow",
                            after = "nvim-treesitter"
                        },
                        {
                            "max397574/nvim-treehopper",
                            after = "nvim-treesitter"
                        }
                        -- {
                        --     "s1n7ax/nvim-comment-frame",
                        --     after = "nvim-treesitter"
                        -- }
                        -- {
                        --     "mfussenegger/nvim-ts-hint-textobject",
                        --     after = "nvim-treesitter",
                        --     desc = "Similar to hop but highlight"
                        -- }
                        -- {
                        --     "romgrk/nvim-treesitter-context",
                        --     after = "nvim-treesitter"
                        -- },
                        -- {
                        --     "yioneko/nvim-yati",
                        --     after = "nvim-treesitter",
                        --     desc = "Yet another tressitter indent"
                        -- },
                    }
                }
            )

            -- use({ "theHamsta/nvim-treesitter-pairs", after = { "nvim-treesitter" } })
            -- use({"nvim-treesitter/nvim-tree-docs", after = {"nvim-treesitter"}})
            -- ]]] === Treesitter ===

            -- ============================= Telescope ============================ [[[
            use(
                {
                    "nvim-telescope/telescope.nvim",
                    opt = false,
                    conf = "plugs.telescope",
                    after = {"popup.nvim", "plenary.nvim", colorscheme},
                    requires = {
                        {
                            "nvim-telescope/telescope-ghq.nvim",
                            after = "telescope.nvim",
                            config = [[require("telescope").load_extension("ghq")]]
                        },
                        {
                            "nvim-telescope/telescope-github.nvim",
                            after = "telescope.nvim",
                            config = [[require("telescope").load_extension("gh")]]
                        },
                        {
                            "nvim-telescope/telescope-frecency.nvim",
                            after = "telescope.nvim",
                            requires = "tami5/sqlite.lua",
                            config = [[require("telescope").load_extension("frecency")]]
                        },
                        {
                            "fannheyward/telescope-coc.nvim",
                            after = "telescope.nvim",
                            config = [[require("telescope").load_extension("coc")]]
                        },
                        {
                            "fhill2/telescope-ultisnips.nvim",
                            after = "telescope.nvim",
                            config = [[require("telescope").load_extension("ultisnips")]]
                        },
                        {
                            "nvim-telescope/telescope-fzf-native.nvim",
                            after = "telescope.nvim",
                            run = "make",
                            config = [[require("telescope").load_extension("fzf")]]
                        },
                        {
                            "dhruvmanila/telescope-bookmarks.nvim",
                            after = "telescope.nvim",
                            config = [[require("telescope").load_extension("bookmarks")]]
                        },
                        {
                            "nvim-telescope/telescope-file-browser.nvim",
                            after = "telescope.nvim",
                            config = [[require("telescope").load_extension("file_browser")]]
                        },
                        {
                            "nvim-telescope/telescope-hop.nvim",
                            after = "telescope.nvim",
                            config = [[require("telescope").load_extension("hop")]]
                        },
                        {
                            "crispgm/telescope-heading.nvim",
                            after = "telescope.nvim",
                            config = [[require("telescope").load_extension("heading")]]
                        },
                        {
                            "nvim-telescope/telescope-smart-history.nvim",
                            requires = {"tami5/sqlite.lua"},
                            after = {"telescope.nvim", "sqlite.lua"},
                            config = [[require("telescope").load_extension("smart_history")]],
                            run = function()
                                local path = Path:new(fn.stdpath("data") .. "/databases/")
                                if not path:exists() then
                                    path:mkdir()
                                end
                            end
                        },
                        {
                            "jvgrootveld/telescope-zoxide",
                            after = "telescope.nvim",
                            config = [[require("telescope").load_extension("zoxide")]]
                        },
                        {
                            prefer_local("telescope-rualdi.nvim"),
                            after = "telescope.nvim",
                            config = [[require("telescope").load_extension("rualdi")]]
                        }
                        -- {
                        --     "nvim-telescope/telescope-ui-select.nvim",
                        --     after = {"telescope.nvim"},
                        --     config = [[require("telescope").load_extension("ui-select")]]
                        -- },
                    }
                }
            )

            use(
                {
                    "nvim-telescope/telescope-packer.nvim",
                    after = {"telescope.nvim"},
                    requires = {
                        "nvim-telescope/telescope.nvim",
                        "wbthomason/packer.nvim"
                    },
                    wants = {"telescope.nvim", "packer.nvim"},
                    -- FIX: Doesn't work all the time and is hard to configure
                    -- config = [[require("telescope").load_extension("packer")]],
                    config = function()
                        require("telescope.builtin").packer = function(opts)
                            -- if not _G.packer_plugins["packer.nvim"].loaded then
                            require("plugins").loader("packer.nvim")
                            ex.packadd("packer.nvim")
                            -- end
                            -- require("plugins").compile()

                            require("telescope").load_extension("packer")
                            require("telescope").extensions.packer.packer(opts)
                        end
                    end
                }
            )

            -- use(
            --     {
            --         "AckslD/nvim-neoclip.lua",
            --         requires = {"nvim-telescope/telescope.nvim", "tami5/sqlite.lua"},
            --         after = {"telescope.nvim", "sqlite.lua"},
            --         conf = "plugs.nvim-neoclip"
            --     }
            -- )
            -- ]]] === Telescope ===

            -- ================================ Git =============================== [[[
            use({"ahmedkhalf/project.nvim", conf = "project", after = "telescope.nvim"})
            use(
                {
                    "tpope/vim-fugitive",
                    fn = "fugitive#*",
                    event = "BufReadPre */.git/index",
                    conf = "plugs.fugitive",
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
                        "Gwrite"
                    },
                    keys = {
                        {"n", "<Leader>gg"},
                        {"n", "<Leader>ge"},
                        {"n", "<Leader>gb"},
                        {"n", "<Leader>gw"},
                        {"n", "<Leader>gr"},
                        {"n", "<Leader>gf"},
                        {"n", "<Leader>gF"},
                        {"n", "<Leader>gC"},
                        {"n", "<Leader>gd"},
                        {"n", "<Leader>gt"}
                    },
                    requires = {"tpope/vim-rhubarb"}
                }
            )

            use(
                {
                    "rbong/vim-flog",
                    cmd = {"Flog", "Flogsplit"},
                    keys = {
                        {"n", "<Leader>gl"},
                        {"n", "<Leader>gi"}
                    },
                    requires = "tpope/vim-fugitive",
                    conf = "plugs.flog"
                }
            )

            use({"kdheepak/lazygit.nvim", conf = "lazygit", after = "telescope.nvim"})

            use(
                {
                    "lewis6991/gitsigns.nvim",
                    conf = "plugs.gitsigns",
                    requires = {"nvim-lua/plenary.nvim"}
                }
            )

            use(
                {
                    "TimUntersberger/neogit",
                    conf = "plugs.neogit",
                    requires = {"nvim-lua/plenary.nvim"}
                }
            )

            use(
                {
                    "ruanyl/vim-gh-line",
                    keys = {
                        {"n", "<Leader>go"},
                        {"n", "<Leader>gL"}
                    },
                    setup = [[vim.g.gh_line_blame_map_default = 0]],
                    conf = "ghline"
                }
            )

            use(
                {
                    "sindrets/diffview.nvim",
                    cmd = {
                        "DiffviewClose",
                        "DiffviewFileHistory",
                        "DiffviewFocusFiles",
                        "DiffviewLog",
                        "DiffviewOpen",
                        "DiffviewRefresh",
                        "DiffviewToggleFiles"
                    },
                    conf = "plugs.diffview",
                    keys = {
                        {"n", "<Leader>g;"},
                        {"n", "<Leader>g."}
                    }
                }
            )

            use(
                {
                    "akinsho/git-conflict.nvim",
                    conf = "git_conflict"
                }
            )

            -- use(
            --     {
            --         "christoomey/vim-conflicted",
            --         cmd = {"Conflicted", "Merger", "GitNextConflict"},
            --         keys = {
            --             "<Plug>DiffgetLocal",
            --             "<Plug>DiffgetUpstream",
            --             "<Plug>DiffgetLocal",
            --             "<Plug>DiffgetUpstream"
            --         }
            --     }
            -- )

            -- ]]] === Git ===

            -- ╭──────────────────────────────────────────────────────────╮
            -- │                          Fennel                          │
            -- ╰──────────────────────────────────────────────────────────╯
            use(
                {
                    "rktjmp/paperplanes.nvim",
                    requires = "rktjmp/hotpot.nvim",
                    conf = "paperplanes",
                    cmd = "PP"
                }
            )

            use(
                {
                    ("%s/%s"):format(fn.stdpath("config"), "lua/plugs/nvim-reload"),
                    conf = "plugs.nvim-reload",
                    opt = true
                }
            )

            use({"rcarriga/nvim-notify", conf = "notify", after = colorscheme})
        end
    }
)
-- use({"mhinz/vim-startify", conf = "plugs.startify"})
