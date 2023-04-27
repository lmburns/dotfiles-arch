---@meta

---@alias NvimOptRet string|integer|table|nil

---@class Nvim
---@field cmd Nvim.Command
---@field command Nvim.Command
---@field cursor fun(win: integer): {[1]: integer, [2]: integer}
---@field echo fun(chunks: Dict<string>[], history?: boolean)
---@field executable fun(exe: string): boolean
---@field exists Nvim.Exists
---@field has Nvim.Exists
---@field keymap Nvim.Keymap
---@field mode fun(): {blocking: boolean, mode: string}
---@field p Nvim.p
---@field plugins Nvim.Plugins
---@field colors Dict<string|number>
---@field augroup Nvim.Augroup
---@field autocmd Nvim.Autocmd
---@field termcodes Dict<string>
---@field mark Nvim.Mark
---@field reg Nvim.Reg
---@field buf Nvim.Buf
---@field win Nvim.Win
---@field tab Nvim.Tab
---@field ui Nvim.Ui
---@field g Nvim.g Global variables (`g:var`)
---@field b Nvim.b Buffer local variables (`b:var`)
---@field w Nvim.w Window local variables (`w:var`)
---@field t Nvim.t Tab page local variables (`t:var`)
---@field v Nvim.v Global predefined vim variables (`v:var`)
---@field env Dict<string|number>
---@field bo vim.bo
local Nvim = {}

-- ---@field l Nvim.l Function local variables (`l:var`)
-- ---@field s Nvim.s Script local variables (`s:var`)

---@class Nvim.g
---@field get fun(var: string, bufnr?: integer): NvimOptRet
---@field set fun(var: string, val: string, bufnr?: integer): NvimOptRet
---@field del fun(var: string, bufnr?: integer): NvimOptRet

---@class Nvim.b
---@field get fun(var: string, bufnr?: integer): NvimOptRet
---@field set fun(var: string, val: string, bufnr?: integer): NvimOptRet
---@field del fun(var: string, bufnr?: integer): NvimOptRet

---@class Nvim.w
---@field get fun(var: string, bufnr?: integer): NvimOptRet
---@field set fun(var: string, val: string, bufnr?: integer): NvimOptRet
---@field del fun(var: string, bufnr?: integer): NvimOptRet

---@class Nvim.t

---@class Nvim.v

---@class Nvim.Augroup
---@field add fun(name: string, clear?: boolean): integer
---@field clear fun(name: string)
---@field del fun(id: string|integer)
---@field get fun(id: string|integer)
---@field get_id fun(name: string|integer)

---@class Nvim.Autocmd
---@field add fun(autocmd: Autocmd, id?: integer): Disposable
---@field get fun(opts: RetrieveAutocommand)
---@field del fun(id: integer)

---@class Nvim.Buf
---@field nr fun(): integer Return the current buffer number
---@field line fun(): string Return the content on the current line
---@field lines fun(): integer Return the number of lines in the buffer
---@operator call():any

---@class Nvim.Command
---@field set fun(name: string, rhs: string|fun(args: CommandArgs), opts: CommandOpts)
---@field del fun(name: string, buffer?: boolean|integer)
---@field get fun(id: string)

---@class Nvim.Exists
---@field cmd fun(cmd: string): boolean
---@field event fun(event: string): boolean
---@field augroup fun(augroup: string): boolean
---@field option fun(option: string): boolean
---@field func fun(func: string): boolean
---@operator call():boolean

---@class Nvim.Keymap
---@field add fun(modes: string|string[], lhs: string, rhs: string|fun(), opts: MapArgs): fun()[]
---@field get fun(mode: string, search?: string, lhs?: boolean, buffer?: boolean)
---@field del fun(modes: string|string[], lhs: string, opts: DelMapArgs)
---@operator call(...):nil

---@class Nvim.Mark
---@field name string Mark name as a string
---@field row integer Row
---@field col integer Column
---@field bufnr integer Buffer number
---@field bufname string Full file path
---@field get fun(mk: string): Nvim.Mark
---@field set fun(mk: string, val: {[1]: integer, [2]: integer}|Nvim.Mark)

---@class Nvim.p
---@operator call(...):nil

---@class Nvim.Plugins
---@operator call():Dict<Dict<any>>

---@class Nvim.Reg

---@class Nvim.Tab
---@field nr fun(): integer Return the current tab number
---@operator call():integer

---@class Nvim.Ui

---@class Nvim.Win
---@field nr fun(): integer Return the current window number
---@operator call():integer

---@class RetrieveAutocommand
---@field group string|integer Autocommand name or id
---@field event string|string[] Event(s) to match against
---@field pattern string|string[] Pattern(s) to match against
local RetrieveAutocommand = {}
