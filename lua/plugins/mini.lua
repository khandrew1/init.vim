return {
    {
        "echasnovski/mini.nvim",
        version = "*",
        lazy = false,
        opts = {
            windows = {
                preview = true,
                width_focus = 30,
                width_preview = 60,
            },
        },
        keys = {
            {
                "<leader>fm",
                function()
                    require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
                end,
                desc = "Open mini.files (directory of current file)"
            },
            {
                "<leader>fM",
                function()
                    require("mini.files").open(vim.uv.cwd(), true)
                end,
                desc = "Open mini.files (cwd)"
            }
        },
        config = function(_, opts)
            require('mini.statusline').setup()
            require('mini.notify').setup()
            vim.notify = require('mini.notify').make_notify()
            require('mini.files').setup(opts)
            require('mini.extra').setup()
            require('mini.hipatterns').setup()
            require('mini.basics').setup({
                mappings = {
                    windows = true
                }
            })
            require('mini.pairs').setup()
            require('mini.keymap').setup()
            require('mini.icons').setup()
        end
    }
}
