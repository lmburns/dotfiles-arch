local M = {}

local D = require("dev")
local yanky = D.npcall(require, "yanky")
if not yanky then
    return
end

local utils = require("common.utils")
local map = utils.map
local C = require("common.color")
local augroup = utils.augroup

-- local wk = require("which-key")
local mapping = require("yanky.telescope.mapping")

function M.setup()
    yanky.setup(
        {
            ring = {
                history_length = 100,
                storage = "shada",
                sync_with_numbered_registers = true
            },
            picker = {
                telescope = {
                    mappings = {
                        default = mapping.put("p"),
                        i = {
                            ["<C-j>"] = mapping.put("p"),
                            ["<C-k>"] = mapping.put("P"),
                            ["<C-x>"] = mapping.delete()
                        },
                        n = {
                            p = mapping.put("p"),
                            P = mapping.put("P"),
                            d = mapping.delete()
                        }
                    }
                }
            },
            system_clipboard = {
                sync_with_ring = true
            },
            highlight = {
                on_put = true,
                on_yank = true,
                timer = 300
            },
            preserve_cursor_position = {
                enabled = false
            }
        }
    )
end

local function init()
    M.setup()

    -- color.set_hl("YankyYanked", {background = "#cc6666"})
    C.set_hl("YankyPut", {background = "#cc6666"})

    -- map({"n", "x"}, "y", "<Plug>(YankyYank)")

    map({"n", "x"}, "p", "<Plug>(YankyPutAfter)")
    map({"n", "x"}, "P", "<Plug>(YankyPutBefore)")
    map({"n", "x"}, "gp", "<Plug>(YankyGPutAfter)")
    map({"n", "x"}, "gP", "<Plug>(YankyGPutBefore)")
    map("n", "<M-p>", "<Plug>(YankyCycleForward)")
    map("n", "<M-P>", "<Plug>(YankyCycleBackward)")

    require("telescope").load_extension("yank_history")
end

init()

return M
