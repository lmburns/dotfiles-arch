local M = {}

local utils = require("common.utils")
local augroup = utils.augroup

local g = vim.g

function M.setup()
    g.vimtex_view_method = "zathura"
    g.tex_flavor = "latex"
    g.vimtex_compiler_latexmk = {
        executable = "latexmk",
        options = {
            "-xelatex",
            "-file-line-error",
            "-synctex=1",
            "-interaction=nonstopmode"
        }
    }
end

local function init()
    M.setup()

    augroup(
        "lmb__Vimtex",
        {event = "InsertEnter", pattern = "*.tex", command = [[set conceallevel=0]]},
        {event = "InsertLeave", pattern = "*.tex", command = [[set conceallevel=2]]},
        {event = "BufEnter", pattern = "*.tex", command = [[set concealcursor-=n]]},
        {event = "VimLeave", pattern = "*.tex", command = [[!texclear %]]}
    )
end

init()

return M
