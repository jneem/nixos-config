{ config, pkgs, inputs, ... }:

{
  programs.helix = {
    enable = true;
    settings = {
      theme = "onedark";
      editor =  {
        auto-pairs = false;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        file-picker.hidden = false;
        search.smart-case = false;
      };
      keys = {
        normal = {
          C-j = "half_page_down";
          C-k = "half_page_up";
          C-d = ":reset-diff-change";
        };
      };
    };
    languages = {
      language = [
        {
          name = "rust";
          file-types = [ "rs" ];
          roots = [".lsproot"];
          indent = { tab-width = 4; unit = "    "; };
        }
        {
          name = "nix";
          file-types = [ "nix" ];
          indent = { tab-width = 2; unit = "  "; };
        }
      ];

      language-server.rust-analyzer.config = {
        checkOnSave = {
          command = "clippy";
        };
      };
      language-server.texlab.config.texlab = {
        auxDirectory = "build";
        chktex = {
          onOpenAndSave = true;
          onEdit = true;
        };
        forwardSearch = {
          executable = "zathura";
          args = [ "--synctex-forward" "%l:%c:%f" "%p" ];
        };
        build = {
          forwardSearchAfter = true;
          onSave = true;
          executable = "latexmk";
          args = [
            "-pdf"
            "-interaction=nonstopmode"
            "-synctex=1"
            "-shell-escape"
            "-output-directory=build"
            "%f"
          ];
        };
      };
    };
  };
}