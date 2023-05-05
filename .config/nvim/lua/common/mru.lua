local M = {}

local debounce = require("common.debounce")

local fs = require("common.utils.fs")
local fss = fs.sync
-- local fsa = fs.async

-- local log = require("common.log")
-- local uva = require("uva")
-- local async = require("async")

local fn = vim.fn
local api = vim.api
local uv = vim.loop

local bufs
local mru = {}

local function list(file)
    local mru_list = {}
    local fname_set = {[""] = true}

    local add_list = function(name)
        if not fname_set[name] then
            fname_set[name] = true
            if uv.fs_stat(name) then
                if #mru_list < mru.max then
                    table.insert(mru_list, name)
                else
                    return false
                end
            end
        end
        return true
    end

    while #bufs > 0 do
        local bufnr = table.remove(bufs)
        if api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].bt == "" then
            local fname = api.nvim_buf_get_name(bufnr)
            if not fname:match(mru.tmp_prefix) and not fname:match("%%") then
                if not add_list(fname) then
                    break
                end
            end
        end
    end

    local fd = io.open(file, "r")
    if fd then
        for fname in fd:lines() do
            if not add_list(fname) then
                break
            end
        end
        fd:close()
    end

    -- fsa.read_file(file):thenCall(
    --     function(data)
    --         for _, fname in ipairs(vim.split(data, "\n")) do
    --             if not add_list(fname) then
    --                 break
    --             end
    --         end
    --     end
    -- ):catch(
    --     function(e)
    --         log.err(e, {print = true})
    --     end
    -- )

    return mru_list
end

function M.list()
    local mru_list = list(mru.db)
    fss.write_file(mru.db, table.concat(mru_list, "\n"))
    -- fsa.writeFile(mru.db, table.concat(mru_list, "\n")):catch(
    --     function(e)
    --         vim.notify(e)
    --     end
    -- )
    return mru_list
end

M.flush =
    (function()
    local debounced
    return function(force)
        if force then
            -- fsa.write_file(mru.db, table.concat(list(mru.db), "\n")):catch(
            --     function(e)
            --         vim.notify(e)
            --     end
            -- )
            fss.write_file(mru.db, table.concat(list(mru.db), "\n"), force)
        else
            if not debounced then
                debounced =
                    debounce:new(
                    function()
                        fss.write_file(mru.db, table.concat(list(mru.db), "\n"))
                        -- fsa.write_file(mru.db, table.concat(list(mru.db), "\n")):catch(
                        --     function(e)
                        --         vim.notify(e)
                        --     end
                        -- )
                    end,
                    50
                )
            end
            debounced()
        end
    end
end)()

M.store_buf = (function()
    local count = 0
    return function()
        local ok, bufnr = pcall(fn.expand, "<abuf>", 1)
        if ok then
            bufnr = bufnr and tonumber(bufnr) or api.nvim_get_current_buf()
            table.insert(bufs, bufnr)
            count = (count + 1) % 10
            if count == 0 then
                M.list()
            end
        end
    end
end)()

---This doesn't have something going on in the background, adding a file to the
---MRU list across sessions. So, this would only involve files opened in the current session.
M.mru_current_session = function()
    local current_buffer = api.nvim_get_current_buf()
    local current_file = api.nvim_buf_get_name(current_buffer)
    local results = {}

    for _, buffer in ipairs(vim.split(fn.execute(":buffers! t"), "\n")) do
        local match = tonumber(buffer:match("%s*(%d+)"))
        local open_by_lsp = buffer:match("line 0$")
        if match and not open_by_lsp then
            local file = api.nvim_buf_get_name(match)
            if uv.fs_stat(file) and match ~= current_buffer then
                table.insert(results, file)
            end
        end
    end

    for _, file in ipairs(vim.v.oldfiles) do
        if uv.fs_stat(file) and not vim.tbl_contains(results, file) and file ~= current_file then
            table.insert(results, file)
        end
    end

    return results
end

local function init()
    bufs = {}
    mru = {
        mtime = 0,
        max = 1000,
        cache = "",
        tmp_prefix = uv.os_tmpdir(),
        db = ("%s/%s"):format(lb.dirs.data, "mru_file")
    }

    if M.list()[1] ~= fn.expand("%:p") then
        M.store_buf()
    end

    nvim.autocmd.Mru = {
        {
            event = {"BufEnter", "BufAdd", "FocusGained"},
            pattern = "*",
            command = function()
                require("common.mru").store_buf()
            end
        },
        {
            event = {"VimLeavePre"},
            pattern = "*",
            command = function()
                require("common.mru").flush(true)
            end
        },
        {
            event = {"VimSuspend", "FocusLost"},
            pattern = "*",
            command = function()
                require("common.mru").flush()
            end
        }
    }
end

init()

return M
