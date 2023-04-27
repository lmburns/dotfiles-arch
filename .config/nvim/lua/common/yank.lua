local M = {}

local utils = require("common.utils")
local mpi = require("common.api")
local W = require("common.api.win")
local augroup = mpi.augroup

local api = vim.api
local F = vim.F

local wv
local winid
local bufnr
local report

---
---@param suffix string
---@return string
function M.wrap(suffix)
    if utils.mode() == "n" then
        M.set_wv()
    else
        M.clear_wv()
    end
    return type(suffix) == "string" and ("y" .. suffix) or "y"
end

---Set window view options
function M.set_wv()
    winid = api.nvim_get_current_win()
    bufnr = api.nvim_get_current_buf()
    wv = W.win_save_positions(bufnr)
    report = vim.o.report
    -- skip `update_topline_redraw` in `op_yank_reg` caller
    vim.o.report = 65535
end

---Reset window view options
function M.clear_wv()
    wv = nil
    winid = nil
    bufnr = nil
    if report then
        vim.o.report = report
        report = nil
    end
end

---Restore window view
function M.restore()
    if
        vim.v.event.operator == "y" and wv and api.nvim_get_current_win() == winid and
            api.nvim_get_current_buf() == bufnr
     then
        wv.restore()
    end
    M.clear_wv()
end

---Yank an item to a given register and notify
---@param regname string register to copy to
---@param context string text to copy
---@param level? number
---@param opts? NotifyOpts
function M.yank_reg(regname, context, level, opts)
    nvim.reg[regname] = context
    vim.notify(context, level, opts)
end

local function init()
    augroup(
        "TextYank",
        {
            event = "TextYankPost",
            pattern = "*",
            command = function()
                require("common.yank").restore()
            end
        }
    )
end

init()

return M
