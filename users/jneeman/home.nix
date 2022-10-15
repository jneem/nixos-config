{ config, pkgs, pkgs-unstable, ... }:

{
  home = rec {
    username = "jneeman";
    homeDirectory = "/home/jneeman";
    sessionVariables = {
      EDITOR = "hx";
    };
    stateVersion = "22.05";
    packages = with pkgs; [
      libsecret
      pari
      ripgrep
      tmux
      wl-clipboard
    ];

  };
  
  programs.home-manager.enable = true;
  
  programs.git = {
    enable = true;
    ignores = [ ".envrc" "untracked-shell.nix" ".direnv" ];
    lfs.enable = true;
    userName = "Joe Neeman";
    userEmail = "joeneeman@gmail.com";
  };
  
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  
  programs.exa = {
    enable = true;
    enableAliases = true;
  };
  
  programs.fish = {
    enable = true;
    shellInit = ''
      set fish_greeting
    '';
  };
  
  programs.helix = {
    enable = true;
    package = pkgs-unstable.helix;
    settings = {
      theme = "onedark";
      editor.auto-pairs = false;
      editor.cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
      };
    };
    languages = [
      {
        name = "rust";
        file-types = ["rs"];
        indent = { tab-width = 4; unit = "    ";};
      }
      {
        name = "nix";
        file-types = ["nix"];
        indent = { tab-width = 2; unit = "  ";};
      }
    ];
  };
  
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };
  
  programs.starship = {
    enable = true;
  };
  
    
}
