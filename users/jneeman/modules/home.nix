{ config, pkgs, inputs, ... }:

{
  imports = [
    ./neovim
    ./helix.nix
  ];
  _module.args.inputs = inputs;

  home = {
    username = "jneeman";
    homeDirectory = "/home/jneeman";
    sessionVariables = {
      EDITOR = "hx";
    };
    stateVersion = "22.05";
    packages = with pkgs; [
      carapace
      lazygit
      libsecret
      git-filter-repo
      pari
      ripgrep
      tealdeer
      tmux
    ];
  };

  programs.git = {
    enable = true;
    ignores = [ ".envrc" ".direnv" ];
    lfs.enable = true;
    userName = "Joe Neeman";
    userEmail = "joeneeman@gmail.com";
    includes = [
      {
        path = "~/tweag/.gitconfig";
        condition = "gitdir:~/tweag/";
      }
    ];
  };

  home.file.tweag-gitconfig = {
    target = "tweag/.gitconfig";
    text = ''
    [user]
    email = joe.neeman@tweag.io
    '';
  };

  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
    nix-direnv.enable = true;
  };

  programs.eza = {
    enable = true;
    enableAliases = true;
  };

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
  };

  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
  };
  home.file = {
    nu-default-config = {
      source = ./default_config.nu;
      target = "/home/jneeman/.config/nushell/default_config.nu";
    };
  };

  programs.fish = {
    enable = true;
    shellInit = ''
      set fish_greeting
    '';
    shellAbbrs = {
      llw = "ll -snew";
    };
  };

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    
    settings = {
      aws.disabled = true;
      gcloud.disabled = true;
      package.disabled = true;
      nix_shell.format = "via [❄️ $name]($style) ";
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "org.pwmt.zathura.desktop";
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };
  };
}
