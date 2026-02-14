return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      local copilot = require 'copilot'
      copilot.setup {
        opts = {
          suggestion = { enabled = true },
        },
      }
    end,
  },
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'j-hui/fidget.nvim',
      {
        'saghen/blink.cmp',
        lazy = false,
        version = '*',
        opts = {
          keymap = {
            preset = 'default',
          },
          cmdline = { sources = { 'cmdline' } },
          sources = {
            default = { 'lsp', 'path', 'buffer', 'codecompanion' },
          },
        },
      },
    },
    config = function()
      local codecompanion = require 'codecompanion'
      codecompanion.setup {
        adapters = {
          http = {
            ollama = function()
              return require('codecompanion.adapters').extend('ollama', {
                name = 'ollama',
                schema = {
                  model = {
                    -- Define the llama model to use here
                    default = 'gpt-oss:20b',
                  },
                  num_ctx = {
                    default = 16384,
                  },
                  num_predict = {
                    default = -1,
                  },
                },
              })
            end,
            copilot = function()
              return require('codecompanion.adapters').extend('copilot', {
                schema = {
                  model = {
                    default = 'claude-sonnet-4.5',
                  },
                },
              })
            end,
          },
        },
        interactions = {
          chat = {
            adapter = 'copilot',
          },
          inline = {
            adapter = 'copilot',
          },
        },
        rules = {
          architecture = {
            description = 'Repository architecture memory management',
            files = {
              'ARCHITECTURE.md',
            },
          },
        },
        extensions = {
          mcphub = {
            callback = 'mcphub.extensions.codecompanion',
            opts = {
              --  MCP Tools
              make_tools = true, -- Make individual tools (@server__tool) and groups (@server) from the MCP Servers
              show_server_tools_in_chat = true, -- Show individual tools in chat completion
              add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g. '@mcp__github')
              show_result_in_chat = true, -- Show tool results directyly in the chat buffer
              format_tool = nil, -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
              -- MCP Resources
              make_vars = true, -- Convert MCP resources to #variables for prompts
              -- MCP Prompts
              make_slash_commands = true, -- Add MCP prompts as /slash commands
            },
          },
        },
      }
      local progress = require 'fidget.progress'
      local handles = {}
      local group = vim.api.nvim_create_augroup('CodeCompanionProgress', {})
      vim.api.nvim_create_autocmd('User', {
        pattern = 'CodeCompanionRequestStarted',
        group = group,
        callback = function(e)
          handles[e.data.id] = progress.handle.create {
            title = 'CodeCompanion',
            message = 'Thinking...',
            lsp_client = { name = e.data.adapter.formatted_name },
          }
        end,
      })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'CodeCompanionRequestFinished',
        group = group,
        callback = function(e)
          local h = handles[e.data.id] -- and e.data.id or nil]
          if h then
            -- local msg = (e.data and e.data.message) or 'Done' or 'Failed'
            h.message = e.data.status == 'success' and 'Done' or 'Failed'
            -- h:report { message = msg }
            h:finish()
            handles[e.data.id] = nil
          end
        end,
      })
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    version = '^8.0',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons', 'nvim-mini/mini.nvim' },
    ft = { 'codecompanion' },
    config = function()
      require('render-markdown').setup {
        file_types = { 'codecompanion' },
        latex = {
          enabled = true,
          converter = 'none',
          highlight = 'RenderMarkdownMath',
          position = 'above',
          top_pad = 0,
          bottom_pad = 0,
        },
        log_level = 'debug', -- Add this line
        overrides = {
          filetype = {
            markdown = {
              latex = {
                enabled = true,
              },
            },
          },
        },
      }
    end,
  },
  --  Keymaps
  vim.keymap.set({ 'n', 'v' }, '<C-a>', '<cmd>CodeCompanionActions<cr>', { noremap = true, silent = true }),
  vim.keymap.set({ 'n', 'v' }, '<LocalLeader>a', '<cmd>CodeCompanionChat Toggle<cr>', { noremap = true, silent = true }),
  vim.keymap.set('v', 'ga', '<cmd>CodeCompanionChat Add<cr>', { noremap = true, silent = true }),
  -- Expand 'cc' into 'CodeCompanion' in the command line
  vim.cmd [[cab cc CodeCompanion]],
}
