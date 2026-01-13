return {
  'GCBallesteros/jupytext.nvim',
  config = true,
  -- Depending on your nvim distro or config you may need to make the loading not lazy
  -- lazy=false,
  custom_language_formatting = {
    python = {
      extension = 'md',
      style = 'markdown',
      force_ft = 'markdown', -- you can set whatever filetype you want here
    },
    r = {
      extension = 'md',
      style = 'markdown',
      force_ft = 'markdown', -- you can set whatever filetype you want here
    },
  },
}
