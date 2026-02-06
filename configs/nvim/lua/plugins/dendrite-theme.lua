return {
  -- Use everforest as the green theme
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.everforest_background = "hard"
      vim.g.everforest_better_performance = 1
      vim.cmd.colorscheme("everforest")
    end,
  },

  -- Tell LazyVim to use everforest
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "everforest",
    },
  },

  -- Custom dashboard with Dendrite branding
  {
    "nvimdev/dashboard-nvim",
    opts = function(_, opts)
      local logo = [[
   ____  _____ _   _ ____  ____  ___ _____ _____
  |  _ \| ____| \ | |  _ \|  _ \|_ _|_   _| ____|
  | | | |  _| |  \| | | | | |_) || |  | | |  _|
  | |_| | |___| |\  | |_| |  _ < | |  | | | |___
  |____/|_____|_| \_|____/|_| \_\___|_|_| |_____|

         TUI Stack for Agentic Coding
      ]]
      logo = string.rep("\n", 4) .. logo .. "\n\n"
      opts.config.header = vim.split(logo, "\n")
    end,
  },
}
