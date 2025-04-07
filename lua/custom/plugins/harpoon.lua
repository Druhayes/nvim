return {
  'ThePrimeagen/harpoon',
  config = function()
    local harpoon = require 'harpoon'

    harpoon.setup {
      global_settings = {
        -- Sets the marks on "toggle" in the ui,  instead of ":w"
        save_on_toggle = false,
        -- Saves harpoon on exit.  Disabling in not recommended
        save_on_change = true,
        -- Sets harpoon to run the command immediately as when called with sendCommand
        enter_on_sendcommand = false,
        -- Close any tmux windows opened in harpoon when neovim is closed
        tmux_autoclose_windows = false,
        -- Filetypes to be exluded from harpoon
        excluded_filetypes = { 'harpoon' },
        -- Set marks specific to each git branch
        mark_branch = true,
        -- Tabline
        tabline = false,
        tabline_prefix = '  ',
        tabline_suffix = '  ',
      },
    }
  end,
}
