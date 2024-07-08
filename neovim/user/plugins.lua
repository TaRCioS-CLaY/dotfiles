local plugins_fennel = require('user.plugins_fennel')
local all_plugins = {
  -- {
  --     'MunifTanjim/prettier.nvim',
  --     event = "BufReadPost",
  --     opts = {
  --         bin = 'prettier', -- or `prettierd`
  --         filetypes = {
  --             "css",
  --             "graphql",
  --             "html",
  --             "javascript",
  --             "javascriptreact",
  --             "json",
  --             "less",
  --             "markdown",
  --             "scss",
  --             "typescript",
  --             "typescriptreact",
  --             "yaml",
  --         }
  --     }
  -- },
  -- {
  --     'Exafunction/codeium.vim',
  --     config = function()
  --         vim.keymap.set('i', '<C-a>', function() return vim.fn['codeium#Accept']() end, { expr = true })
  --         vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true })
  --         vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true })
  --         vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true })
  --     end
  -- }
  -- {
  --     "jcdickinson/codeium.nvim",
  --     dependencies = {
  --         "nvim-lua/plenary.nvim",
  --         "MunifTanjim/nui.nvim",
  --         "hrsh7th/nvim-cmp",
  --     },
  --     config = function()
  --         require("codeium").setup({
  --         })
  --     end
  -- },


  -- {
  --   "nvim-neotest/neotest",
  --   load = "VeryLazy",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-neotest/neotest-jest",
  --     "antoinemadec/FixCursorHold.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     "mfussenegger/nvim-dap",
  --   },
  --   keys = {},
  --   -- opts = {
  --   --   adapters = {
  --   --     ["neotest-jest"] = {
  --   --       -- jestCommand = "npm run test",
  --   --       jestConfigFile = "jest.config.js",
  --   --       env = { CI = true },
  --   --     --   cwd = function(path)
  --   --     --     return vim.fn.getcwd()
  --   --     --   end,
  --   --     -- },
  --   --   },
  --   --   status = { virtual_text = true },
  --   --   output = { open_on_run = true },
  --   --   quickfix = {
  --   --     open = function()
  --   --       if require("lazyvim.util").has("trouble.nvim") then
  --   --         require("trouble").open({ mode = "quickfix", focus = false })
  --   --       else
  --   --         vim.cmd("copen")
  --   --       end
  --   --     end,
  --   --   },
  --   -- },
  --   -- config = function()
  --   --   require("neotest").setup({
  --   --     discovery = {
  --   --       enabled = false,
  --   --     },
  --   --   })
  --   -- end,
  --   keys = {
  --     {
  --
  --       '<leader>rn',
  --       function()
  --         require('neotest').run.run()
  --       end,
  --       desc = 'Rodar teste atual'
  --     },
  --     {
  --       '<leader>rf',
  --       function()
  --         require('neotest').run.run(vim.fn.expand('%'))
  --       end,
  --       desc = 'Rodar testes do arquivo'
  --     },
  --     {
  --       '<leader>rr',
  --       function()
  --         require('neotest').run.run_last()
  --       end,
  --       desc = 'Rodar ultimo teste'
  --     },
  --     {
  --       '<leader>rd',
  --       function()
  --         require('neotest').run.run_last({ strategy = 'dap' })
  --       end,
  --       desc = 'Rodar ultimo teste com dap'
  --     },
  --     {
  --       '<leader>rp',
  --       function()
  --         require('neotest').output_panel.toggle()
  --       end,
  --       desc = 'Mostrar painel de saida'
  --     },
  --     {
  --       '<leader>rs',
  --       function()
  --         require('neotest').summary.toggle()
  --       end,
  --       desc = 'Mostrar sumario'
  --     },
  --     {
  --       '<leader>ro',
  --       function()
  --         require('neotest').output.open({ enter = true })
  --       end,
  --       desc = 'Abrir painel de saida'
  --     },
  --     {
  --       '[t',
  --       function()
  --         require('neotest').jump.prev({ status = 'failed' })
  --       end,
  --       desc = 'Ir para teste anterior'
  --     },
  --     {
  --       ']t',
  --       function()
  --         require('neotest').jump.next({ status = 'failed' })
  --       end,
  --       desc = 'Ir para proximo teste'
  --     },
  --     {
  --       '<leader>R',
  --       function()
  --         require('neotest').run.stop()
  --       end,
  --       desc = 'Parar execucao'
  --     },
  --     {
  --       '<leader>rW',
  --       function()
  --         require('neotest').watch.watch()
  --       end,
  --       desc = 'Rodar em modo watch'
  --     },
  --     {
  --       '<leader>rw',
  --       function()
  --         require('neotest').watch.toggle()
  --       end,
  --       desc = 'Rodar em modo watch toggle'
  --     }
  --   },
  --   config = function()
  --     require('neotest').setup({
  --       adapters = {
  --         require('neotest-jest')({
  --           jestConfigFile = 'jest.config.js',
  --           env = { CI = true },
  --         }),
  --         -- require("neotest-vim-test")({
  --         --     ignore_file_types = { "python", "vim", "lua" },
  --         -- }),
  --       },
  --       quickfix = {
  --         enabled = false,
  --         open = false,
  --       },
  --       output_panel = {
  --         open = 'rightbelow vsplit | resize 30',
  --       },
  --       status = {
  --         virtual_text = true,
  --         signs = true,
  --       },
  --     })
  --   end,
  -- },
  {
    "rebelot/kanagawa.nvim"
  }
}

for _, plugin in pairs(plugins_fennel) do
  table.insert(all_plugins, plugin)
end

return all_plugins
