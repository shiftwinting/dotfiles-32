local utils = require("utils")
local opt = utils.opt
local cmd = utils.cmd
local map = utils.map

-- options
utils.g.mapleader = ","
opt("o", "mouse", "a")
opt("o", "clipboard", "unnamedplus")
opt("o", "ignorecase", true)
opt("o", "smartcase", true)
opt("o", "termguicolors", true)
opt("o", "foldlevelstart", 99)
opt("o", "showcmd", false)
opt("o", "showmode", false)
opt("o", "backup", false)
opt("o", "writebackup", false)
opt("o", "updatetime", 300)
opt("o", "splitbelow", true)
opt("o", "splitright", true)
opt("o", "hidden", true)
opt("o", "completeopt", "menuone,noinsert,noselect")
opt("o", "pumheight", 10)

opt("b", "undofile", true)
opt("b", "tabstop", 4)
opt("b", "shiftwidth", 4)
opt("b", "expandtab", true)

opt("w", "number", true)
opt("w", "relativenumber", true)
opt("w", "cursorline", true)
opt("w", "signcolumn", "yes")
-- not sure how to set this without vim.cmd
cmd("set shortmess+=c")

-- functions, commands, and autocommands
cmd("command! Remove call delete(expand('%')) | bdelete!")

function _G.HighlightOnYank()
    vim.highlight.on_yank {higroup = "IncSearch", timeout = 500}
end

function _G.ToggleQuickFix()
    local closed = vim.api.nvim_eval(
                       "empty(filter(getwininfo(), 'v:val.quickfix'))")
    if closed == 1 then
        cmd("copen")
    else
        cmd("cclose")
    end
end

cmd [[augroup YankHighlight]]
cmd [[autocmd!]]
cmd [[autocmd TextYankPost * silent! lua HighlightOnYank()]]
cmd [[augroup END]]

cmd [[augroup CreateDirectory]]
cmd [[autocmd!]]
cmd [[autocmd BufWritePre,FileWritePre * silent! call mkdir(expand('<afile>:p:h'), 'p')]]
cmd [[augroup END]]

-- bindings
map("n", "H", "^")
map("o", "H", "^")
map("x", "H", "^")
map("n", "L", "$")
map("o", "L", "$")
map("x", "L", "$")

map("n", "<Space>", ":")
map("v", "<Space>", ":")

map("n", "<Tab>", "%")
map("x", "<Tab>", "%")
map("o", "<Tab>", "%")

map("i", "<C-h>", "<Left>")
map("i", "<C-j>", "<Down>")
map("i", "<C-k>", "<Up>")
map("i", "<C-l>", "<Right>")

map("n", "<BS>", "<C-^>")
map("n", "Y", "y$")
map("n", "<Bslash>", ",")
map("n", "ZZ", ":wqall<CR>")
map("n", "<Leader>x", ":bd<CR>", {silent = true})
map("n", "<Esc>", ":nohl<CR>", {silent = true})
map("n", "<Leader>q", ":lua ToggleQuickFix()<CR>")

-- expand pairs
map("i", "(;", "(<CR>)<C-c>O")
map("i", "{;", "{<CR>}<C-c>O")
map("i", "[;", "[<CR>]<C-c>O")

-- save w/ <CR> in non-quickfix buffers
map("n", "<CR>", "(&buftype is# 'quickfix' ? '<CR>' : ':w<CR>')", {expr = true})

-- add jumps > 1 to jump list
map("n", "k", [[(v:count > 1 ? "m'" . v:count : '') . 'k'"]], {expr = true})
map("n", "j", [[(v:count > 1 ? "m'" . v:count : '') . 'j'"]], {expr = true})

-- expand current file's directory to quickly edit file
map("n", "<Leader>e", ":edit <C-r>=expand('%:h')<CR>/")

-- load remaining lua config
if (utils.config_file_exists("theme.lua")) then require("theme") end
if (utils.config_file_exists("plugins/init.lua")) then require("plugins") end
if (utils.config_file_exists("lsp/init.lua")) then require("lsp") end