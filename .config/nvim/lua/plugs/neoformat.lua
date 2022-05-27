local M = {}

local utils = require("common.utils")
local map = utils.map
local augroup = utils.augroup
local coc = require("plugs.coc")
local gittool = require("common.gittool")
local utils = require("common.utils")

local ex = nvim.ex
local g = vim.g
local api = vim.api
local fn = vim.fn

local scan = require("plenary.scandir")

local function save_doc(bufnr)
    vim.schedule(
        function()
            api.nvim_buf_call(
                bufnr,
                function()
                    ex.sil_("up")
                end
            )
        end
    )
end

local function neoformat()
    local bufnr = api.nvim_get_current_buf()
    -- This is a little dense
    if
        vim.bo[bufnr].ft == "lua" and
            #F.if_nil(
                scan.scan_dir(
                    gittool.root() or fn.expand("%:p:h"),
                    {search_pattern = "%.?stylua.toml$", hidden = true, silent = true, respect_gitignore = true}
                ),
                {}
            ) > 0
     then
        ex.Neoformat("stylua")
    else
        ex.Neoformat()
    end

    ex.sil_("up")
end

---Format the document using `Neoformat`
---@param save boolean whether to save the document
function M.format_doc(save)
    save = save == nil and true or save

    local restore = utils.save_win_positions(nvim.buf.nr())

    gittool.root_exe(
        function()
            if coc.did_init() then
                local bufnr = nvim.buf.nr()
                local err, res =
                    coc.a2sync(
                    "hasProvider",
                    {
                        "format"
                    },
                    2000
                )
                if not err and res == true then
                    fn.CocActionAsync(
                        "format",
                        "",
                        function(e, res)
                            -- This is only needed if Sumneko-Coc is used
                            -- Otherwise, formatting can be disabled, and hasProvider returns false
                            -- Now, result has to be checked as false here
                            if e ~= vim.NIL or (vim.bo[bufnr].ft == "lua" and res == false) then
                                api.nvim_buf_call(
                                    bufnr,
                                    function()
                                        neoformat()
                                    end
                                )
                            else
                                if save then
                                    save_doc(bufnr)
                                end
                            end
                        end
                    )
                else
                    neoformat()
                end
            else
                neoformat()
            end
        end
    )

    restore()
end

---Format selected text
---@param mode boolean
---@param save boolean whether to save file
function M.format_selected(mode, save)
    save = save == nil and true or save
    if not coc.did_init() then
        return
    end

    gittool.root_exe(
        function()
            local err, res =
                coc.a2sync(
                "hasProvider",
                {
                    mode and "formatRange" or "format"
                },
                2000
            )
            if not err and res == true then
                local bufnr = api.nvim_get_current_buf()
                fn.CocActionAsync(
                    mode and "formatSelected" or "format",
                    mode,
                    function(e, _)
                        if e ~= vim.NIL then
                            vim.notify(e, vim.log.levels.WARN)
                        else
                            if vim.bo[bufnr].ft == "lua" then
                                neoformat()
                            end

                            if save then
                                save_doc(bufnr)
                            end
                        end
                    end
                )
            end
        end
    )
end

-- TODO: Get keepj keepp to prevent neoformat from modifying changes
--       g; moves to last line after format
local function init()
    g.neoformat_basic_format_retab = 1
    g.neoformat_basic_format_trim = 1
    g.neoformat_basic_format_align = 1

    -- g.neoformat_enabled_lua = { "luaformat" }
    -- g.neoformat_enabled_lua = { "luafmt" }

    -- g.neoformat_enabled_teal = {
    --     "luaformat"
    -- }

    g.neoformat_enabled_python = {
        "black"
    }
    g.neoformat_enabled_zsh = {
        "expand"
    }
    g.neoformat_enabled_java = {
        "prettier"
    }

    -- g.neoformat_enabled_typescript = {
    --     "clangformat", "prettier"
    -- }

    g.neoformat_enabled_yaml = {
        "prettier"
    }
    g.neoformat_yaml_prettier = {
        exe = "prettier",
        args = {
            "--stdin-filepath",
            '"%:p"',
            "--tab-width=2"
        },
        stdin = 1
    }

    g.neoformat_enabled_sql = {
        "sqlformatter"
    }
    g.neoformat_sql_sqlformatter = {
        exe = "sql-formatter",
        args = {
            "--indent",
            "4"
        },
        stdin = 1
    }

    g.neoformat_enabled_json = {
        "jq"
    }
    g.neoformat_json_jq = {
        exe = "jq",
        args = {
            "--indent",
            "4",
            "--tab"
        },
        stdin = 1
    }

    map("n", ";ff", [[:lua require('plugs.neoformat').format_doc()<CR>]])
    map("x", ";ff", [[:lua require('plugs.neoformat').format_selected(vim.fn.visualmode())<CR>]])

    augroup(
        "lmb__Formatting",
        {
            event = "FileType",
            pattern = "crystal",
            command = function()
                map("n", ";ff", "<Cmd>CrystalFormat<CR>")
            end
        }
        -- {
        --     -- Why isn't the only one enabled selected by default?
        --     event = "FileType",
        --     pattern = "typescript",
        --     command = function()
        --         map("n", ";ff", "<Cmd>keepp keepj Neoformat! typescript clangformat<CR>")
        --     end
        -- }
        -- {
        --     event = "FileType",
        --     pattern = "lua",
        --     command = function()
        --         map("n", ";ff", "<Cmd>Neoformat! lua luafmt<CR>")
        --         -- map("n", ";ff", "<Cmd>Neoformat! lua luaformat<CR>")
        --     end
        -- }
    )

    -- [[FileType java       nmap ;ff :Neoformat! java   prettier<CR>]],
    -- [[FileType perl       nmap ;ff :Neoformat! perl<CR>]],
    -- [[FileType sh         nmap ;ff :Neoformat! sh<CR>]],
    -- [[FileType python     nmap ;ff :Neoformat! python black<CR>]],
    -- [[FileType md,vimwiki nmap ;ff :Neoformat!<CR>]],
    -- [[FileType zsh        nmap ;ff :Neoformat  expand<CR>]],
end

init()

return M
