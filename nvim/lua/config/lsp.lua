local M = {}

function M.setup()
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "ts_ls", "bashls" },
    handlers = {
      function(server)
        require("lspconfig")[server].setup({ capabilities = capabilities })
      end,
    },
  })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
    callback = function(args)
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = desc, silent = true })
      end

      map("n", "gd", vim.lsp.buf.definition, "Go to definition")
      map("n", "gr", require("telescope.builtin").lsp_references, "References")
      map("n", "K", vim.lsp.buf.hover, "Hover docs")
      map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
      map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
      map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
      map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
    end,
  })
end

return M
