vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.tabstop=2
vim.opt.softtabstop=2
vim.opt.shiftwidth=2

vim.opt.wrap = false

vim.g.mapleader = " "

-- OmniSharp
vim.g.OmniSharp_server_use_mono = 1
vim.g.OmniSharp_server_use_net6 = 1
vim.g.OmniSharp_selector_ui = 'fzf'

-- ALE
vim.g.ale_linters = {cs = {'OmniSharp'}, lua = {'selene'}}
