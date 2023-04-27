-- ╒══════════════════════════════════════════════════════════╕
--                            Result
-- ╘══════════════════════════════════════════════════════════╛
-- A simple Result<V, E> type
-- This allows for a Result similar to rust
---@class Result
---@field Ok table A non-error value returned from a function
---@field Err table An error value returned from a function
local Result = {}

-- ╒══════════════════════════════════════════════════════════╕
--                              Ok
-- ╘══════════════════════════════════════════════════════════╛
---@class Ok
---@field ok boolean Whether the value represents a successful result
---@field value any The value of the result
local Ok = {}
setmetatable(
    Ok,
    {
        __call = function(self, value)
            -- r.ok = true
            -- r.err = false
            -- r.value = value
            self.ok = value
            return self
        end,
        __tostring = function(r)
            if type(r.ok) == "nil" then
                return "Result::Ok(nil)"
            elseif type(r.ok) == "table" then
                return ("Result::Ok(%s)"):format(vim.tbl_map(vim.inspect, r.ok))
            else
                return ("Result::Ok(%s)"):format(r.ok)
            end
        end,
        __eq = function(r1, r2)
            -- return r1.ok == true and r2.ok == true and r1.value == r2.value and r1.err == r2.err
            return r1.ok == r2.ok and r1.err == r2.err
        end
    }
)

---Execute `f` if the Result is Ok, else return an Err
---@param f function
---@vararg any
---@return Ok|Err
function Ok:and_then(f, ...)
    local r = f(...)
    if r == nil then
        return Result.err("Result == nil (and_then) " .. vim.inspect(debug.traceback()))
    end

    self.ok = r.ok
    self.err = r.err
    setmetatable(self, getmetatable(r))
    return self
end

---Return the Ok result
---@return Ok
function Ok:or_else()
    return self
end

---Map the successful result
---@param f function
---@return Ok
function Ok:map_ok(f)
    self.ok = f(self.ok) or self.ok
    return self
end

---Map the non-existing error
---@return Ok
function Ok:map_err()
    return self
end

---Return the underlying value
---@return Ok
function Ok:unwrap()
    return self
end

---Return the underlying value
---@return Ok
function Ok:unwrap_or()
    return self
end

---Test whether the result is okay
---@return boolean
function Ok:is_ok()
    return self.err ~= true
end

Ok.__index = Ok

-- ╒══════════════════════════════════════════════════════════╕
--                             Err
-- ╘══════════════════════════════════════════════════════════╛
---@class Err
---@field err boolean Whether the value represents an unsuccessful result
---@field value any The value of the error
local Err = {}

setmetatable(
    Err,
    {
        __call = function(t, value)
            t.err = true
            t.value = value
            return t
        end,
        __tostring = function(t)
            if type(t.value) == "nil" then
                return "Result::Error(nil)"
            else
                return "Result::Error(" .. t.value .. ")"
            end
        end,
        __eq = function(e1, e2)
            return e1.__error == true and e2.__error == true and e1.value == e2.value
        end
    }
)

---Return the underlying error to do something else with
---@return Err
function Err:and_then()
    return self
end

---Execute a function if result is an error
---@param f function Function to execute if result is an error
---@vararg any Arguments to the function
---@return Err
function Err:or_else(f, ...)
    local r = f(...)
    if r == nil then
        return Result.err("Result == nil (or_else) " .. vim.inspect(debug.traceback()))
    end

    self.ok = r.ok
    self.err = r.err
    setmetatable(self, getmetatable(r))
    return self
end

---Return the underlying error
---@return Err
function Err:map_ok()
    return self
end

---Execute a function on underlying error
---@param f function
---@return Err
function Err:map_err(f)
    self.err = f(self.err) or self.err
    return self
end

---Return the underlying error
---@return Err
function Err:unwrap()
    return self
end

---Execute a function if the underlying value is an error
---@param f function Function to execute (no parameters)
---@return Err
function Err:unwrap_or(f)
    return f()
end

---Test whether the result is an error
---@return boolean
function Err:is_err()
    return self.err == true
end

---Check whether given value is an error
---@param o any
function Err:is_instance(o)
    if type(o) ~= "nil" then
        return Err() == o
    else
        return false
    end
end

Err.__index = Err

-- local function wrap(cb)
--     local ok, res = pcall(cb)
--     if ok then
--         return Ok(res)
--     end
--
--     return Err(res)
-- end

---Create a Result from a value. If `nil`, then Error
---@param o any
function Result:from_nil(o)
    if type(o) == "nil" then
        return Err(o)
    else
        return Ok(o)
    end
end

Result.ok = function(val)
    if val == nil then
        val = true
    end
    local r = setmetatable({}, Ok)
    r.ok = val
    return r
end

Result.err = function(err)
    if err == nil then
        err = true
    end
    local r = setmetatable({}, Err)
    r.err = err
    return r
end

return Result
