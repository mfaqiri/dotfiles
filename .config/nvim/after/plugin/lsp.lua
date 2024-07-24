local lsp = require('lsp-zero')
require('flutter-tools').setup {}
local lsp_config = require('lspconfig')

lsp.preset('recommended')

lsp.ensure_installed({
    'tsserver',
    'eslint',
    'lua_ls',
    'rust_analyzer',
    'omnisharp'
})

lsp_config.gdscript.setup{capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())}

local dartExcludedFolders = {
                vim.fn.expand("$HOME/AppData/Local/Pub/Cache"),
                vim.fn.expand("$HOME/.pub-cache"),
                vim.fn.expand("/opt/homebrew/"),
                vim.fn.expand("$HOME/tools/flutter/"),
}

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space'] = cmp.mapping.complete(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
})


lsp.setup_nvim_cmp({
    mappings = cmp_mappings
})

vim.api.nvim_create_autocmd('LspAttach', {

        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)

            local opts = { buffer = ev.buf }

            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', '<leader>zws', vim.lsp.buf.workspace_symbol, opts)
            vim.keymap.set('n', '<leader>zd', vim.diagnostic.open_float, opts)
            vim.keymap.set('n', '[d', vim.diagnostic.goto_next, opts)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_prev, opts)
            vim.keymap.set('n', '<leader>vca', vim.lsp.buf.code_action, opts)
            vim.keymap.set('n', '<leader>vrr', vim.lsp.buf.references, opts)
            vim.keymap.set('n', '<leader>vrn', vim.lsp.buf.rename, opts)
            vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts)
        end,
})

lsp_config["emmet_ls"].setup({filetypes = {'templ'}})

lsp_config["dartls"].setup({
        capabilities = capabilities,
        cmd = {
                        "dart",
                        "language-server",
                        "--protocol=lsp",
                        -- "--port=8123",
                        -- "--instrumentation-log-file=/Users/robertbrunhage/Desktop/lsp-log.txt",
                        },
        filetypes = { "dart" },
        init_options = {
                        onlyAnalyzeProjectsWithOpenFiles = false,
                        suggestFromUnimportedLibraries = true,
                        closingLabels = true,
                        outline = false,
                        flutterOutline = false,
                        },
                        settings = {
                        dart = {
                                analysisExcludedFolders = dartExcludedFolders,
                                updateImportsOnRename = true,
                                completeFunctionCalls = true,
                                showTodos = true,
                                },
                        },
})



lsp.setup()
