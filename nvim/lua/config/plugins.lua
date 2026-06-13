-- neovim プラグイン設定（lazy.nvim で管理）
-- UI の見た目と操作性を改善するプラグイン群

return {
  -- ============================================================
  -- UI テーマ・ビジュアル
  -- ============================================================
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,  -- 他のプラグインより先に読み込む
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",  -- ダーク系の温かみのある配色
      })
      vim.cmd.colorscheme "catppuccin"
    end
  },

  -- ============================================================
  -- バッファ・タブ表示
  -- ============================================================
  {
    "romgrk/barbar.nvim",
    dependencies = {
      "lewis6991/gitsigns.nvim",      -- Git 変更状況表示
      "nvim-tree/nvim-web-devicons",  -- ファイルアイコン
    },
    init = function() vim.g.barbar_auto_setup = false end,
  },

  -- ============================================================
  -- ステータスライン
  -- ============================================================
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("lualine").setup()
    end
  },

  -- ============================================================
  -- ファイルエクスプローラー
  -- ============================================================
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup()
    end
  },

  -- ============================================================
  -- コード解析・シンタックスハイライト
  -- ============================================================
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",  -- パーサーを自動更新
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "vim", "python", "javascript", "go", "bash", "json" },
        highlight = { enable = true },  -- シンタックスハイライト
        indent = { enable = true },      -- 自動インデント
      })
    end
  },

  -- ============================================================
  -- ターミナル統合
  -- ============================================================
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup()
    end
  },

  -- ============================================================
  -- LSP・補完機能
  -- ============================================================
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright", "gopls" },
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "mason-lspconfig.nvim" },
    config = function()
      local lspconfig = require("lspconfig")

      -- 新しい API で LSP サーバーを有効化
      local servers = { "lua_ls", "pyright", "gopls" }
      for _, server in ipairs(servers) do
        lspconfig[server].setup({})
      end

      -- lua_ls の特別な設定
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })
    end
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",  -- LSP 補完ソース
      "hrsh7th/cmp-buffer",     -- バッファ補完ソース
      "hrsh7th/cmp-path",       -- パス補完ソース
      "hrsh7th/cmp-nvim-lua",   -- Lua API 補完
      "L3MON4D3/LuaSnip",       -- スニペットエンジン
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "InsertEnter",
    config = function()
      require("lsp_signature").setup()
    end
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup()
    end
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "mason.nvim" },
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = "VeryLazy",
    dependencies = {
      "mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      require("mason-null-ls").setup({
        ensure_installed = { "prettier", "black", "stylua" },
      })
    end
  },

  -- ============================================================
  -- Git 統合
  -- ============================================================
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "-" },
          topdelete = { text = "-" },
          changedelete = { text = "~" },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end
          -- Hunk ナビゲーション
          map('n', ']c', function() gs.next_hunk() end)
          map('n', '[c', function() gs.prev_hunk() end)
          -- Hunk ステージング・リセット
          map('n', '<leader>hs', function() gs.stage_hunk() end)
          map('n', '<leader>hu', function() gs.undo_stage_hunk() end)
          map('n', '<leader>hr', function() gs.reset_hunk() end)
        end,
      })
    end
  },
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterToggle",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("lazygit").setup()
    end
  },
  {
    "sindrets/diffview.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("diffview").setup()
    end
  },

  -- ============================================================
  -- ウィンドウ管理
  -- ============================================================
  {
    "simeji/winresizer",
  },

  -- ============================================================
  -- 編集機能拡張
  -- ============================================================
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",  -- Insert モード時に読み込む
    config = function()
      require("nvim-autopairs").setup()
    end
  },
  {
    "pocco81/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },  -- 編集終了時に読み込む
    config = function()
      require("auto-save").setup()
    end
  },

  -- ============================================================
  -- Markdown・ドキュメント
  -- ============================================================
  {
    "toppair/peek.nvim",
    event = "VeryLazy",
    build = "deno task --quiet build:fast",  -- Deno でビルド
    config = function()
      require("peek").setup()
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end
  },

  -- ============================================================
  -- 開発支援機能
  -- ============================================================
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup()
    end
  },

  -- ============================================================
  -- コマンドライン補完
  -- ============================================================
  {
    "gelguy/wilder.nvim",
    event = "CmdlineEnter",
    config = function()
      local wilder = require("wilder")
      wilder.setup({ modes = { ":", "/", "?" } })
      wilder.set_option("renderer", wilder.popupmenu_renderer({
        highlighter = wilder.basic_highlighter(),
        left = { " ", wilder.popupmenu_devicons() },
        right = { " ", wilder.popupmenu_scrollbar() },
      }))
    end,
  },
}
