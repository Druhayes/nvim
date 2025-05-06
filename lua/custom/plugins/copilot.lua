return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = true,
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'github/copilot.vim' }, -- or github/copilot.vim
      { 'nvim-lua/plenary.nvim', branch = 'master' }, -- for curl, log and async functions
    },
    build = 'make tiktoken', -- Only on MacOS or Linux
    config = function()
      local copilot = require 'CopilotChat'
      copilot.setup {
        mappings = {
          complete = {
            insert = '<C-y>',
          },
          submit_prompt = {
            normal = '<CR>',
            insert = '<C-s>',
          },
        },
      }
    end,
  },
}
