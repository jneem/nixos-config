{ pkgs, ... }:

with pkgs.vimPlugins;
[
  lsp_extensions-nvim
  lsp_signature-nvim
  lspkind-nvim
  {
    plugin = nvim-lspconfig;
    type = "lua";
    config = builtins.readFile ./lspconfig.lua;
  }
  {
    plugin = fidget-nvim;
    type = "lua";
    config = ''
      require('fidget').setup({})
    '';
  }
  {
    plugin = rust-tools-nvim;
    type = "lua";
    config = ''
      require('rust-tools').setup({
        server = {
          on_attach = on_attach,
          standalone = false,
        }
      })
    '';
  }
]
