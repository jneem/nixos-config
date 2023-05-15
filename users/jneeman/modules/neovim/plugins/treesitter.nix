{ pkgs, ... }:

with pkgs.vimPlugins;
[
  {
    plugin = nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars);
    type = "lua";
    config = ''
      require('nvim-treesitter.configs').setup({
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
      })
    '';
  }
]
