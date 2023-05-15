{ pkgs, ... }:

with pkgs.vimPlugins;
[
  cmp-buffer
  cmp-cmdline
  cmp-nvim-lsp
  cmp-omni
  cmp-path
  cmp-treesitter
  cmp_luasnip
  luasnip
  {
    plugin = nvim-cmp;
    type = "lua";
    config = builtins.readFile ./cmp.lua;
  }
]
