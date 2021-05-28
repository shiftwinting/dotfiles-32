local u = require("utils")

local format = string.format
local api = vim.api

local send_command = function(cmd)
    vim.cmd("silent! VtrSendCtrlC")
    vim.cmd(format("VtrSendCommandToRunner! %s", cmd))
end

local get_params = function()
    return vim.bo.filetype, vim.fn.bufname(api.nvim_get_current_buf())
end

local commands = {
    file = {
        lua = "FILE=%s make test-file",
        typescript = "npm run test -- %s",
        typescriptreact = "npm run test -- %s"
    },
    suite = {
        lua = "make test",
        typescript = "npm run test:cov",
        typescriptreact = "npm run test:cov"
    }
}

_G.vtr = {
    test = function()
        local ft, fname = get_params()
        send_command(format(commands.file[ft], fname))
    end,
    test_suite = function()
        local ft = get_params()
        send_command(commands.suite[ft])
    end
}
u.command("VtrTest", "lua vtr.test()")
u.command("VtrTestSuite", "lua vtr.test_suite()")

u.augroup("VtrExit", "VimLeave", "silent! VtrKillRunner")

u.map("n", "to", ":VtrOpenRunner<CR>")
u.map("n", "tl", ":VtrFlushCommand<CR>")
u.map("n", "tt", ":VtrSendCommandToRunner!<CR>")
u.map("n", "tf", ":VtrTest<CR>")
u.map("n", "ts", ":VtrTestSuite<CR>")
u.map("n", "tk", ":VtrKillRunner<CR>")
u.map("n", "ta", ":VtrSendFile<CR>")