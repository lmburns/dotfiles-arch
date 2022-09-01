---@diagnostic disable:undefined-field

local M = {}

local utils = require("common.utils")

local api = vim.api
local F = vim.F
local fn = vim.fn

---@class RetrieveAutocommand
---@field group string|number Autocommand name or id
---@field event string|string[] Event(s) to match against
---@field pattern string|string[] Pattern(s) to match against

---@class Nvim.Augroup
---@field add fun(name: string, clear?: boolean): number
---@field clear fun(name: string)
---@field del fun(id: string|number)
---@field get fun(id: string|number)
---@field get_id fun(name: string|number)

---@class Nvim.Autocmd
---@field add fun(autocmd: Autocommand, id?: number): Disposable
---@field get fun(opts: RetrieveAutocommand)
---@field del fun(id: number)

---@class Nvim.Buf
---@field nr fun(): number #Return the current buffer number
---@field line fun(): number #Return the content on the current line

---@class Nvim.Command
---@field set fun(name: string, rhs: string|fun(args: CommandArgs), opts: CommandOpts)
---@field del fun(name: string, buffer?: boolean|number)
---@field get fun(id: string)

---@class Nivm.Keymap
---@field add fun(modes: string|string[], lhs: string, rhs: string|function, opts: MapArgs): fun()[]
---@field get fun(mode: string, search?: string, lhs?: boolean, buffer?: boolean)
---@field del fun(modes: string|string[], lhs: string, opts: DelMapArgs)

---@class Nvim
---@field augroup Nvim.Augroup
---@field autocmd Nvim.Autocmd
---@field b table
---@field bo table
---@field buf Nvim.Buf
---@field buffer Nvim.Buf
---@field builtin_echo fun(chunks: { [string]: string }[], history?: boolean)
---@field cmd Nvim.Command
---@field colors table
---@field command Nvim.Command
---@field cursor fun(win: number): (number, number)
---@field echo fun(chunks: { [string]: string }[], history?: boolean)
---@field env table
---@field executable fun(exe: string): boolean
---@field exists table
---@field has table
---@field keymap Nivm.Keymap
---@diagnostic disable-next-line:assign-type-mismatch
local nvim = require("nvim")
---@diagnostic disable-next-line:assign-type-mismatch
_G.nvim = require("nvim")

-- local nvim: Nvim {
--     mode: unknown,
--     p: table,
--     plugins: table,
--     reg: table,
--     t: table,
--     tab: table,
--     termcodes: table,
--     ui: table,
--     win: table,
-- }

---Get an autocmd
---@param opts RetrieveAutocommand
---@return table
local function get_autocmd(opts)
    vim.validate {opts = {opts, "table", true}}
    opts = opts or {}

    local ok, autocmds = pcall(api.nvim_get_autocmds, opts)
    if not ok then
        autocmds = {}
    end
    return autocmds
end

---Get an augroup
---@param name_id string|number
---@return table
local function get_augroup(name_id)
    vim.validate {
        name_id = {name_id, {"s", "n"}, "Augroup name string or id number"}
    }
    return get_autocmd({group = name_id})
end

---Return augroup ID
---@param name string|number
---@return number
local function get_augroup_id(name)
    local groups = get_augroup(name)
    if #groups > 0 then
        return groups[1].group
    end
    return -1
end

---Add an augroup
---@param name string Augroup name
---@param clear? boolean Clear the augroup
---@return number
local function add_augroup(name, clear)
    vim.validate {
        name = {name, "string"},
        clear = {clear, "boolean", true}
    }

    local groups = get_augroup(name)
    if #groups == 0 or clear then
        return utils.create_augroup(name, clear == true)
    end
    return groups[1].group
end

---Clear an `augroup`
---@param name string
local function clear_augroup(name)
    vim.validate {name = {name, "string"}}
    utils.create_augroup(name, true)
end

---Delete an augroup
---@param name_id string|number
local function del_augroup(name_id)
    vim.validate {
        name_id = {
            name_id,
            {"s", "n"},
            "Augroup name string or id number"
        }
    }

    local api_call = type(name_id) == "string" and api.nvim_del_augroup_by_name or api.nvim_del_augroup_by_id
    pcall(api_call, name_id)
end

nvim.plugins =
    setmetatable(
    {},
    {
        __index = function(self, k)
            local mt = getmetatable(self)
            local x = mt[k]

            if x ~= nil then
                return x
            end

            local ok, plugs = pcall(api.nvim_get_var, "plugs")
            if plugs[k] then
                mt[k] = plugs[k]
                return plugs[k]
            end

            if not ok and _G.packer_plugins then
                plugs = _G.packer_plugins
                if plugs[k] and plugs[k].loaded then
                    return plugs[k]
                end
            end

            return nil
        end,
        __call = function(_, _)
            return _G.packer_plugins
        end
    }
)

local exists_tbl = {
    cmd = function(cmd)
        return fn.exists(":" .. cmd) == 2
    end,
    event = function(event)
        return fn.exists("##" .. event) == 2
    end,
    augroup = function(augroup)
        return fn.exists("#" .. augroup) == 1
    end,
    option = function(option)
        return fn.exists("+" .. option) == 1
    end,
    func = function(func)
        return fn.exists("*" .. func) == 1
    end
}

---Shortcut for `fn.has()`
nvim.has =
    setmetatable(
    exists_tbl,
    {
        __call = function(_, feature)
            return api.nvim_call_function("has", {feature}) == 1
        end
    }
)

---Shortcut for `fn.exists()`
nvim.exists =
    setmetatable(
    exists_tbl,
    {
        __call = function(_, feature)
            return api.nvim_call_function("exists", {feature}) == 1
        end
    }
)

---Has access to `line` and `nr`
nvim.buffer = nvim.buf
nvim.cmd = nvim.command

---Equivalent to `api.nvim_win_get_cursor`
nvim.cursor = api.nvim_win_get_cursor

---Equivalent to `api.nvim_get_mode`
nvim.mode = api.nvim_get_mode

---Access to all `termcodes`
nvim.termcodes = utils.termcodes

---Equivalent to `echo` EX command
nvim.builtin_echo = nvim.echo

---Echo a single colored message
nvim.p =
    setmetatable(
    {},
    {
        __index = function(super, group)
            group = utils.get_default(rawget(super, group), group)

            return setmetatable(
                {},
                {
                    ---@param msg string message to echo
                    ---@param history boolean? add message to history
                    ---@param wait number? amount of time to wait
                    __call = function(_, msg, history, wait)
                        utils.cool_echo(msg, group, history, wait)
                    end
                }
            )
        end,
        __call = function(_, ...)
            utils.cool_echo(...)
        end
    }
)

---Equivalent to `api.nvim_echo`. Allows multiple commands
---@param chunks { [string]: string }[]
---@param history boolean
nvim.echo = function(chunks, history)
    vim.validate(
        {
            chunks = {chunks, "t"},
            history = {history, "b", true}
        }
    )
    api.nvim_echo(chunks, history or true, {})
end

-- These are all still accessible as something like nvim.buf_get_current_commands(...)

---Access to `api.nvim_buf_.*`
nvim.buf =
    setmetatable(
    {
        nr = nvim.buffer.nr,
        line = nvim.buffer.line
    },
    {
        __index = function(self, k)
            local mt = getmetatable(self)
            local x = mt[k]
            if x ~= nil then
                return x
            end
            local f = api["nvim_buf_" .. k]
            mt[k] = f
            return f
        end,
        __call = function(_, ...)
            return api.nvim_get_current_buf(...)
        end
    }
)

---Access to `api.nvim_win_.*`
nvim.win =
    setmetatable(
    {
        nr = api.nvim_get_current_win
    },
    {
        __index = function(self, k)
            local mt = getmetatable(self)
            local x = mt[k]
            if x ~= nil then
                return x
            end
            local f = api["nvim_win_" .. k]
            mt[k] = f
            return f
        end,
        __call = function(_, ...)
            return api.nvim_get_current_win(...)
        end
    }
)

---Access to `api.nvim_tabpage_.*`
nvim.tab =
    setmetatable(
    {
        nr = api.nvim_get_current_tabpage
    },
    {
        __index = function(self, k)
            local mt = getmetatable(self)
            local x = mt[k]
            if x ~= nil then
                return x
            end
            local f = api["nvim_tabpage_" .. k]
            mt[k] = f
            return f
        end,
        __call = function(_, ...)
            return api.nvim_get_current_tabpage(...)
        end
    }
)

---Access to `api.nvim_ui_.*`
nvim.ui =
    setmetatable(
    {},
    {
        __index = function(self, k)
            local mt = getmetatable(self)
            local x = mt[k]
            if x ~= nil then
                return x
            end
            local f = api["nvim_ui_" .. k]
            mt[k] = f
            return f
        end
    }
)

---Access to registers
nvim.reg =
    setmetatable(
    {},
    {
        __index = function(_, k)
            local ok, value = pcall(api.nvim_call_function, "getreg", {k})
            return ok and value or nil
        end,
        __newindex = function(_, k, v)
            if v == nil then
                error("Can't clear registers")
            end
            pcall(api.nvim_call_function, "setreg", {k, v})
        end
    }
)

---Use `nvim.command[...]` or `nvim.command.get()` to list all
nvim.command =
    setmetatable(
    {
        set = utils.command,
        del = utils.del_command,
        get = function(k)
            local cmds = api.nvim_get_commands({})
            if k == nil then
                return cmds
            end

            return F.if_nil(cmds[k], {})
        end
    },
    {
        __index = function(self, k)
            local mt = getmetatable(self)
            local x = mt[k]
            if x ~= nil then
                return x
            end

            return self.get(k)
        end
    }
)

-- Allow this to be callable without explicitly calling `.add`
nvim.keymap =
    setmetatable(
    {
        add = utils.map,
        get = utils.get_keymap,
        del = utils.del_keymap
    },
    {
        __index = function(self, mode)
            vim.validate {mode = {mode, "s"}}

            local modes =
                _t(
                {
                    "n",
                    "i",
                    "v",
                    "o",
                    "s",
                    "x",
                    "t",
                    "c"
                }
            )

            if not modes:contains(mode) then
                error("Invalid mode")
            end
            return self.get(mode)
        end,
        __call = function(self, bufnr, modes, lhs, rhs, opts)
            self.add(bufnr, modes, lhs, rhs, opts)
        end
    }
)

---Modify `augroup`s
nvim.augroup =
    setmetatable(
    {
        add = add_augroup,
        del = del_augroup,
        get = get_augroup,
        get_id = get_augroup_id,
        clear = clear_augroup
    },
    {
        __index = function(self, k)
            local mt = getmetatable(self)
            local x = mt[k]
            if x ~= nil then
                return x
            end
            local cmds = get_augroup(k)
            return #cmds > 0 and cmds or nil
        end,
        __newindex = function(_, k, v)
            if type(k) == type "" and k ~= "" then
                if v == nil then
                    del_augroup(k)
                elseif type(v) == type {} then
                    local autocmds
                    if vim.tbl_islist(v) then
                        autocmds = vim.deepcopy(v)
                    else
                        autocmds = {v}
                    end

                    for _, aucmd in ipairs(autocmds) do
                        if aucmd.group then
                            local group = aucmd.group
                            aucmd.group = nil
                            utils.augroup(group, aucmd)
                        else
                            utils.autocmd(aucmd)
                        end
                    end
                end
            end
        end
    }
)

---Modify `autocmd`s
nvim.autocmd =
    setmetatable(
    {
        add = utils.autocmd,
        get = get_autocmd,
        del = function(id)
            vim.validate {id = {id, "number"}}
            pcall(api.nvim_del_autocmd, id)
        end
    },
    -- Can do nvim.autocmd["User"] to list User autocmds
    {
        __index = function(self, k)
            local mt = getmetatable(self)
            local x = mt[k]
            if x ~= nil then
                return x
            end
            local cmds = get_autocmd({event = k})
            return #cmds > 0 and cmds or nil
        end,
        __newindex = function(_, k, v)
            if type(k) == "string" and k ~= "" and type(v) == "table" then
                local autocmds = F.tern(vim.tbl_islist(v), vim.deepcopy(v), {v})
                utils.augroup(k, unpack(autocmds))
            end
        end
    }
)

---Global access to check whether something is executable
---@param exec string
---@return boolean
nvim.executable = function(exec)
    return utils.executable(exec)
end

---Access highlight groups
nvim.colors =
    setmetatable(
    {},
    {
        __index = function(_, k)
            -- Why is this an error without a return?
            return R("common.color")[k]
        end,
        __newindex = function(_, hlgroup, opts)
            R("common.color")[hlgroup] = opts
        end,
        __call = function(_, k)
            return R("common.color")(k)
        end
    }
)

-- ╭──────────────────────────────────────────────────────────╮
-- │                        Variables                         │
-- ╰──────────────────────────────────────────────────────────╯

---Access environment variables
nvim.env =
    setmetatable(
    {},
    {
        __index = function(_, k)
            local ok, value = pcall(api.nvim_call_function, "getenv", {k})
            if not ok then
                value = api.nvim_call_function("expand", {"$" .. k})
                value = value == k and nil or value
            end
            if not value then
                value = os.getenv(k)
            end
            return value or nil
        end,
        __newindex = function(_, k, v)
            local ok, _ = pcall(api.nvim_call_function, "setenv", {k, v})
            if not ok then
                v = type(v) == "string" and ('"%s"'):format(v) or v
                local _ = api.nvim_eval(("let $%s = %s"):format(k, v))
            end
        end
    }
)

---Access to `tabpage` variables (i.e., `t:var`)
nvim.t =
    setmetatable(
    {},
    {
        __index = function(_, k)
            local ok, value = pcall(api.nvim_tabpage_get_var, 0, k)
            return ok and value or nil
        end,
        __newindex = function(_, k, v)
            if v == nil then
                return api.nvim_tabpage_del_var(0, k)
            else
                return api.nvim_tabpage_set_var(0, k, v)
            end
        end
    }
)

return M
