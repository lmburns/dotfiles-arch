---@class Plugin
---@field after string | string[]: Specifies plugins to load before this plugin.
---@field as string: Specifies an alias under which to install the plugin
---@field branch string: Specifies a git branch to use
---@field cmd string | string[]: Specifies commands which load this plugin.  Can be an autocmd pattern.
---@field commit string: Specifies a git commit to use
---@field cond string | function | string[]: Specifies a conditional test to load this plugin
---@field config string | function: Specifies code to run after this plugin is loaded.
---@field disable boolean: Mark a plugin as inactive
---@field event string | string[]: Specifies autocommand events which load this plugin.
---@field fn string | string[]: Specifies functions which load this plugin.
---@field ft string | string[]: Specifies filetypes which load this plugin.
---@field installer function: Specifies custom installer
---@field keys string | string[]: Specifies maps which load this plugin
---@field lock boolean: Skip updating this plugin in updates/syncs. Still cleans.
---@field module string | string[]: Specifies Lua module names for require. When requiring a string which starts
---@field module_pattern string | string[]: Specifies Lua pattern of Lua module names for require. When requiring a string
---@field opt boolean: Manually marks a plugin as optional.
---@field requires string string[]: Specifies plugin dependencies
---@field rocks string | string[]: Specifies Luarocks dependencies for the plugin
---@field rtp string: Specifies a subdirectory of the plugin to add to runtimepath.
---@field run string | function | table: Post-update/install hook
---@field setup string | function: Specifies code to run before this plugin is loaded.
---@field tag string: Specifies a git tag to use. Supports '*' for "latest tag"
---@field updater function: Specifies custom updater

-- local control = {}
-- for plugin, tbl in pairs(_G.packer_plugins) do
--     control[plugin] = false
-- end
-- p(control)

local M = {
    ["Comment.nvim"] = false,
    ["FixCursorHold.nvim"] = false,
    ["Nvim-R"] = false,
    ScratchPad = false,
    ["Spacegray.vim"] = false,
    UnconditionalPaste = false,
    ["aerial.nvim"] = false,
    ["arshlib.nvim"] = false,
    ["better-escape.nvim"] = false,
    ["blue-moon"] = false,
    bogster = false,
    ["bufferize.vim"] = false,
    ["bufferline.nvim"] = false,
    catppuccin = false,
    ["close-buffers.nvim"] = false,
    ["coc-code-action-menu"] = false,
    ["coc-fzf"] = false,
    ["coc-kvs"] = false,
    ["coc.nvim"] = false,
    ["comment-box.nvim"] = false,
    ["crates.nvim"] = false,
    ["daycula-vim"] = false,
    ["desktop-notify.nvim"] = false,
    ["dial.nvim"] = false,
    ["diffview.nvim"] = false,
    ["dressing.nvim"] = false,
    edge = false,
    ["editorconfig-vim"] = false,
    ["eregex.vim"] = false,
    everforest = false,
    fzf = false,
    ["fzf-floaterm"] = false,
    ["fzf-lua"] = false,
    ["fzf.vim"] = false,
    ["fzy-lua-native"] = false,
    ["git-conflict.nvim"] = false,
    ["gitsigns.nvim"] = false,
    ["gruvbox-flat.nvim"] = false,
    ["gruvbox-material"] = false,
    hexmode = false,
    ["hlargs.nvim"] = false,
    ["hop.nvim"] = false,
    ["hotpot.nvim"] = false,
    ["iceberg.vim"] = false,
    ["id3.vim"] = false,
    ["impatient.nvim"] = false,
    ["incline.nvim"] = false,
    ["indent-blankline.nvim"] = false,
    ["info.vim"] = false,
    ["iswap.nvim"] = false,
    ["kanagawa.nvim"] = false,
    kimbox = false,
    ["lazygit.nvim"] = false,
    ["legendary.nvim"] = false,
    ["levuaska.nvim"] = false,
    ["lf-vim"] = false,
    ["lf.nvim"] = false,
    ["linediff.vim"] = false,
    ["listish.nvim"] = false,
    ["lua-dev.nvim"] = false,
    ["lualine.nvim"] = false,
    ["lush.nvim"] = false,
    ["luv-vimdocs"] = false,
    ["marks.nvim"] = false,
    ["material.nvim"] = false,
    melange = false,
    miramare = false,
    ["move.nvim"] = false,
    ["neodark.vim"] = false,
    neoformat = false,
    neogen = false,
    neogit = false,
    ["night-owl.vim"] = false,
    ["nightfox.nvim"] = false,
    ["nlua.nvim"] = false,
    ["nui.nvim"] = false,
    ["nvim-autopairs"] = false,
    ["nvim-bqf"] = false,
    ["nvim-colorizer.lua"] = false,
    ["nvim-dap"] = false,
    ["nvim-dap-python"] = false,
    ["nvim-dap-ui"] = false,
    ["nvim-dap-virtual-text"] = false,
    ["nvim-gps"] = false,
    ["nvim-hclipboard"] = false,
    ["nvim-hlslens"] = false,
    ["nvim-luapad"] = false,
    ["nvim-luaref"] = false,
    ["nvim-neoclip.lua"] = false,
    ["nvim-notify"] = false,
    ["nvim-regexplainer"] = false,
    ["nvim-scrollbar"] = false,
    ["nvim-treehopper"] = false,
    ["nvim-treesitter"] = false,
    ["nvim-treesitter-endwise"] = false,
    ["nvim-treesitter-refactor"] = false,
    ["nvim-treesitter-textobjects"] = false,
    ["nvim-trevJ.lua"] = false,
    ["nvim-ts-autotag"] = false,
    ["nvim-ts-context-commentstring"] = false,
    ["nvim-ts-rainbow"] = false,
    ["nvim-ufo"] = false,
    ["nvim-web-devicons"] = false,
    ["nvim.lua"] = false,
    nvim_context_vt = false,
    ["oceanic-material"] = false,
    ["one-small-step-for-vimkind"] = false,
    ["onenord.nvim"] = false,
    ["open-browser.vim"] = false,
    ["package-info.nvim"] = false,
    ["packer.nvim"] = false,
    ["paperplanes.nvim"] = false,
    playground = false,
    ["plenary.nvim"] = false,
    ["popup.nvim"] = false,
    ["possession.nvim"] = false,
    ["project.nvim"] = false,
    ["promise-async"] = false,
    ["registers.nvim"] = false,
    rnvimr = false,
    ["ron.vim"] = false,
    ["rose-pine"] = false,
    ["rust.vim"] = false,
    ["smart-splits.nvim"] = false,
    sonokai = false,
    spaceduck = false,
    ["specs.nvim"] = false,
    ["spellsitter.nvim"] = false,
    ["sqlite.lua"] = false,
    ["substitute.nvim"] = false,
    ["suda.vim"] = false,
    ["syntax-tree-surfer"] = false,
    ["targets.vim"] = false,
    ["telescope-bookmarks.nvim"] = false,
    ["telescope-coc.nvim"] = false,
    ["telescope-dap.nvim"] = false,
    ["telescope-file-browser.nvim"] = false,
    ["telescope-frecency.nvim"] = false,
    ["telescope-fzf-native.nvim"] = false,
    ["telescope-ghq.nvim"] = false,
    ["telescope-github.nvim"] = false,
    ["telescope-heading.nvim"] = false,
    ["telescope-hop.nvim"] = false,
    ["telescope-packer.nvim"] = false,
    ["telescope-rualdi.nvim"] = false,
    ["telescope-smart-history.nvim"] = false,
    ["telescope-ultisnips.nvim"] = false,
    ["telescope-zoxide"] = false,
    ["telescope.nvim"] = false,
    ["tmux.nvim"] = false,
    ["todo-comments.nvim"] = false,
    ["toggleterm.nvim"] = false,
    ["tokyodark.nvim"] = false,
    ["tokyonight.nvim"] = false,
    ["treesitter-unit"] = false,
    ["trouble.nvim"] = false,
    ["twilight.nvim"] = false,
    ultisnips = false,
    undotree = false,
    ["urlview.nvim"] = false,
    ["vCoolor.vim"] = false,
    ["vim-SpellCheck"] = false,
    ["vim-anyfold"] = false,
    ["vim-asterisk"] = false,
    ["vim-cargo-make"] = false,
    ["vim-caser"] = false,
    ["vim-crystal"] = false,
    ["vim-deep-space"] = false,
    ["vim-devicons"] = false,
    ["vim-easy-align"] = false,
    ["vim-floaterm"] = false,
    ["vim-flog"] = false,
    ["vim-fugitive"] = false,
    ["vim-gh-line"] = false,
    ["vim-gnupg"] = false,
    ["vim-go"] = false,
    ["vim-grepper"] = false,
    ["vim-gutentags"] = false,
    ["vim-indent-object"] = false,
    ["vim-ingo-library"] = false,
    ["vim-just"] = false,
    ["vim-markdown"] = false,
    ["vim-matchup"] = false,
    ["vim-nightfly-guicolors"] = false,
    ["vim-perl"] = false,
    ["vim-polyglot"] = false,
    ["vim-repeat"] = false,
    ["vim-rhubarb"] = false,
    ["vim-rustpeg"] = false,
    ["vim-sandwich"] = false,
    ["vim-slime"] = false,
    ["vim-snippets"] = false,
    ["vim-startuptime"] = false,
    ["vim-table-mode"] = false,
    ["vim-teal"] = false,
    ["vim-visual-multi"] = false,
    ["vim-xxdcursor"] = false,
    vimtex = false,
    vimwiki = false,
    vinfo = false,
    ["vista.vim"] = false,
    ["which-key.nvim"] = false,
    ["wilder.nvim"] = false,
    ["zen-mode.nvim"] = false,
    ["zig.vim"] = false
}

return M
