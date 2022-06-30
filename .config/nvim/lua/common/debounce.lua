local uv = vim.loop

---@class Debounce
---@field timer userdata|nil
---@field fn function
---@field args table
---@field wait number
---@field leading? boolean
local Debounce = {}

---Create a new `Debounce` instance
---@param fn function
---@param wait number
---@param leading? boolean
---@return Debounce
function Debounce:new(fn, wait, leading)
    vim.validate(
        {
            fn = {fn, "function"},
            wait = {wait, "number"},
            leading = {leading, "boolean", true}
        }
    )
    local obj = {}
    ---@cast self -?
    setmetatable(obj, self)
    obj.timer = nil
    obj.fn = vim.schedule_wrap(fn)
    obj.args = nil
    obj.wait = wait
    obj.leading = leading
    return obj
end

---Execute the function to debounce.
--- This is called when the returned function from this module is called
---@vararg any
function Debounce:call(...)
    local timer = self.timer
    self.args = {...}
    if not timer then
        timer = uv.new_timer()
        self.timer = timer
        local wait = self.wait
        timer:start(
            wait,
            wait,
            self.leading and function()
                    self:cancel()
                end or function()
                    self:flush()
                end
        )
        if self.leading then
            self.fn(...)
        end
    else
        timer:again()
    end
end

function Debounce:cancel()
    local timer = self.timer
    if timer then
        if timer:has_ref() then
            timer:stop()
            if not timer:is_closing() then
                timer:close()
            end
        end
        self.timer = nil
    end
end

function Debounce:flush()
    if self.timer then
        self:cancel()
        self.fn(unpack(self.args))
    end
end

---ref() returns a normal function which, when called, calls Debounce:call()
---bound to the original instance.
---Useful for using Debounce with an API that doesn't accept callable tables.
function Debounce:ref()
    return function(...)
        self:call(...)
    end
end

Debounce.__index = Debounce
Debounce.__call = Debounce.call

return setmetatable(
    Debounce,
    {
        __call = Debounce.new
    }
)
