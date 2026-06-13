-- lua ディレクトリを runtimepath に追加
vim.opt.rtp:prepend(vim.fn.stdpath("config") .. "/lua")

-- leader の設定
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- nvim-lspconfig の非推奨警告を抑制（v3.0.0 まで有効）
vim.g.lspconfig_suppress_deprecation_warning = true

-- lazy.nvim のブートストラップ
local lazypath = vim.fn.stdpath("data") .. "/site/pack/packer/start/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 設定ファイルの読み込み
require("config.options")
require("config.keymaps")
require("config.autocmd")

-- lazy.nvim でプラグイン管理を初期化
require("lazy").setup("config.plugins")
