return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle file explorer" },
    { "<leader>E", "<cmd>Neotree focus<cr>", desc = "Focus file explorer" },
  },
  opts = {
    close_if_last_window = false,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    default_component_configs = {
      container = {
        enable_character_fade = true,
      },
      indent = {
        indent_size = 2,
        padding = 1,
        with_markers = true,
        indent_marker = "│",
        last_indent_marker = "└",
        highlight = "NeoTreeIndentMarker",
        with_expanders = true,
        expander_collapsed = "",
        expander_expanded = "",
        expander_highlight = "NeoTreeExpander",
      },
      icon = {
        folder_closed = "",
        folder_open = "",
        folder_empty = "󰜌",
        default = "󰈔",
        highlight = "NeoTreeDirectoryIcon",
      },
      modified = {
        symbol = "●",
        highlight = "NeoTreeModified",
      },
      name = {
        trailing_slash = false,
        use_git_status_colors = true,
        highlight = "NeoTreeFileName",
      },
      git_status = {
        symbols = {
          added = "󰐕",
          modified = "󰏫",
          deleted = "󰆴",
          renamed = "󰁕",
          untracked = "󰄨",
          ignored = "󰈟",
          unstaged = "󰄱",
          staged = "󰄬",
          conflict = "󰞇",
        },
      },
      file_size = { enabled = false },
      type = { enabled = false },
      last_modified = { enabled = false },
      created = { enabled = false },
    },
    window = {
      position = "left",
      width = 36,
      mapping_options = {
        noremap = true,
        nowait = true,
      },
      mappings = {
        ["<space>"] = "none",
        ["<cr>"] = "open",
        ["l"] = "open",
        ["h"] = "close_node",
        ["<BS>"] = "navigate_up",
        ["."] = "toggle_hidden",
        ["H"] = "toggle_hidden",
        ["R"] = "refresh",
        ["Y"] = {
          function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.fn.setreg("+", path, "c")
          end,
          desc = "Copy path",
        },
      },
    },
    filesystem = {
      hijack_netrw_behavior = "disabled",
      use_libuv_file_watcher = true,
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
      group_empty_dirs = true,
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false,
        hide_by_name = {
          ".git",
          "node_modules",
          ".DS_Store",
          "thumbs.db",
        },
      },
    },
  },
  config = function(_, opts)
    require("neo-tree").setup(opts)

    -- Sidebar styling aligned with tokyonight
    vim.api.nvim_set_hl(0, "NeoTreeNormal", { link = "NormalFloat" })
    vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { link = "NormalFloat" })
    vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { link = "NormalFloat" })
    vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { link = "WinSeparator" })
    vim.api.nvim_set_hl(0, "NeoTreeCursorLine", { link = "CursorLine" })
    vim.api.nvim_set_hl(0, "NeoTreeIndentMarker", { link = "Comment" })
  end,
}
