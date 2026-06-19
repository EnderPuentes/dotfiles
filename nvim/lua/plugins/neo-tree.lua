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
    enable_diagnostics = false,
    enable_opened_markers = true,
    source_selector = {
      winbar = true,
      statusline = false,
      show_scrolled_off_parent_node = true,
      sources = {
        { source = "filesystem", display_name = " EXPLORER " },
      },
      tabs_layout = "active",
      separator = { left = "", right = "" },
      highlight_tab = "NeoTreeTabInactive",
      highlight_tab_active = "NeoTreeTabActive",
    },
    default_component_configs = {
      container = {
        enable_character_fade = false,
        width = "100%",
        right_padding = 0,
      },
      indent = {
        indent_size = 2,
        padding = 1,
        with_markers = true,
        indent_marker = "·",
        last_indent_marker = "·",
        with_expanders = true,
        expander_collapsed = "▸",
        expander_expanded = "▾",
        expander_highlight = "NeoTreeExpander",
      },
      icon = {
        folder_closed = "󰉋",
        folder_open = "󰝰",
        folder_empty = "󰉖",
        folder_empty_open = "󰝰",
        default = "󰈔",
        highlight = "NeoTreeFileIcon",
      },
      modified = {
        symbol = "●",
        highlight = "NeoTreeModified",
      },
      name = {
        trailing_slash = false,
        highlight_opened_files = "name",
        use_git_status_colors = false,
        highlight = "NeoTreeFileName",
      },
      git_status = {
        symbols = {
          added = "A",
          modified = "M",
          deleted = "D",
          renamed = "R",
          untracked = "U",
          ignored = "",
          unstaged = "!",
          staged = "S",
          conflict = "C",
        },
      },
      file_size = { enabled = false },
      type = { enabled = false },
      last_modified = { enabled = false },
      created = { enabled = false },
    },
    renderers = {
      directory = {
        { "indent" },
        { "icon" },
        {
          "container",
          content = {
            { "name", zindex = 10 },
            { "git_status", zindex = 10, align = "right", hide_when_expanded = false },
          },
        },
      },
      file = {
        { "indent" },
        { "icon" },
        {
          "container",
          content = {
            { "name", zindex = 10 },
            { "modified", zindex = 20, align = "right" },
            { "git_status", zindex = 10, align = "right" },
          },
        },
      },
    },
    window = {
      position = "left",
      width = 32,
      auto_expand_width = false,
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
        ["i"] = "show_file_details",
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
      group_empty_dirs = false,
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
    require("config.highlights").setup_neotree_highlights()
  end,
}
