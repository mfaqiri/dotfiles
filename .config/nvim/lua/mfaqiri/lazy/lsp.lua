return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lua',
        'L3MON4D3/LuaSnip',
        'rafamadriz/friendly-snippets',
        'stevearc/dressing.nvim',
        'j-hui/fidget.nvim',
        'akinsho/flutter-tools.nvim'
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require('cmp_nvim_lsp')
        local capabilities = vim.tbl_deep_extend(
            'force',
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())


        require('flutter-tools').setup {}
        require('fidget').setup({})
        require('mason').setup()
        require('mason-lspconfig').setup({
            ensure_installed = {
                'tsserver',
                'eslint',
                'lua_ls',
                'rust_analyzer',
                'omnisharp'
            },
            handlers = {
            function(server_name)
                require('lspconfig')[server_name].setup {
			        capabilities = capabilities
			}
			end,

            ['lua_ls'] = function()
                local lspconfig = require('lspconfig')
                lspconfig.lua_ls.setup {
                    capabilities = capabilities,
                    settings = {
                        Lua = {
                            runtime = { version = 'Lua 5.1' },
                            diagnostics = {
                                globals = { 'bit', 'vim', 'it', 'describe', 'before_each', 'after_each' },
                            }
                        }
                    }
                }
                 end,

            ['dartls'] = function()
                local lspconfig = require('lspconfig')
                local dartExcludedFolders = {
                    vim.fn.expand("$HOME/AppData/Local/Pub/Cache"),
                    vim.fn.expand("$HOME/.pub-cache"),
                    vim.fn.expand("/opt/homebrew/"),
                    vim.fn.expand("$HOME/tools/flutter/"),
                }
                lspconfig.dartls.setup {
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
                }
            end,

            ['emmet_ls'] = function()
                local lspconfig = require('lspconfig')
                lspconfig.emmet_ls.setup {
                    capabilities = capabilities,
                    filetypes = { "templ" },
                }
            end,

            }
        })


        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        cmp.setup = ({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },

            mapping = cmp.mapping.preset.insert({
            ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
            ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
            ['<C-y>'] = cmp.mapping.confirm({ select = true }),
            ['<C-Space'] = cmp.mapping.complete(),
        }),

        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
         }, {
            { name = 'buffer' },
         })
        })

		vim.diagnostic.config({
			float = {
				focusable = false,
				style = 'minimal',
				border = 'rounded',
				source = 'always',
				header = '',
				prefix = '',
			},
		})
	end
}
