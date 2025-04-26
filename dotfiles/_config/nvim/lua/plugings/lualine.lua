return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections.lualine_c = { { "filename", path = 4 } }
      table.insert(opts.sections.lualine_x, "searchcount")
      opts.sections.lualine_y = { "encoding", "fileformat", "filetype" }
      opts.sections.lualine_z = { "progress", "location" }
    end,
  },
}
