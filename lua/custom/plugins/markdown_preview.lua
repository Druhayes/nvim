return {
  'iamcco/markdown-preview.nvim',
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  ft = { 'markdown' },
  build = function()
    -- First try the built-in install function
    local success = pcall(vim.fn['mkdp#util#install'])
    if not success then
      -- If that fails, install manually
      vim.fn.system('cd ' .. vim.fn.stdpath 'data' .. '/lazy/markdown-preview.nvim/app && npm install')
    end
  end,
  config = function()
    -- Optional: Configure to use Firefox
    vim.g.mkdp_browser = 'firefox'
  end,
}
