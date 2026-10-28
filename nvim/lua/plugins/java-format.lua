return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.java = { "google-java-format" }
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "google-java-format" } },
  },
}
