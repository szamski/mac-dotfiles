return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = true,
    opts = {
      terminal_colors = true,
      transparent_mode = false,
      contrast = "", -- can be "hard", "soft" or empty string
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  },
}
