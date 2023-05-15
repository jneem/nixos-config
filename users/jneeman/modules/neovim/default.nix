{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      {
        plugin = crates-nvim;
        type = "lua";
        config = ''
          require('crates').setup({})
        '';
      }
      {
        plugin = nvim-base16;
        config = ''
          colorscheme base16-tokyo-city-dark
        '';
      }
      {
        plugin = trouble-nvim;
        type = "lua";
        config = ''
          require('trouble').setup({})
        '';
      }
      nvim-web-devicons
      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = ''
          require('nvim-tree').setup({})
        '';
      }
    ] ++ (with pkgs.lib; with builtins; pipe ./plugins [
      readDir
      attrNames
      (filter (hasSuffix ".nix"))
      (concatMap (filename: import ./plugins/${filename} { inherit pkgs; }))
    ]);
    extraConfig = ''
      set number     " line numbers
      set expandtab  " expand tabs to spaces
    '';
  };

}
