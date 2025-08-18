return {
    'nvim-lualine/lualine.nvim',
      dependencies = {
    -- display macro recording
    { "yavorski/lualine-macro-recording.nvim" }
  },
    config = function()
            require('lualine').setup({
            options = {
                theme = "tokyonight-storm"
            },
            sections = {
                lualine_c = {
                    "macro_recording", "%S" ,
                }
            }
        })
    end
}
