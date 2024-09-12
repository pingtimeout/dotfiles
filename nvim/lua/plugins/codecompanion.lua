return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim", -- Optional
    {
      "stevearc/dressing.nvim", -- Optional: Improves the default Neovim UI
      opts = {},
    },
  },
  config = {
    strategies = {
      chat = {
        adapter = "codestral",
      },
      inline = {
        adapter = "codestral",
      },
      agent = {
        adapter = "codestral",
      },
    },
    adapters = {
      codestral = function()
        return require("codecompanion.adapters").extend("ollama", {
          name = "codestral",
          schema = {
            model = {
              default = "codestral:latest",
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
    },
  },
}
