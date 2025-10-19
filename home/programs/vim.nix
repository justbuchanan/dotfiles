{ config, pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    vimAlias = true;

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha"; # Options: latte, frappe, macchiato, mocha
      };
    };

    opts = {
      number = true;
      relativenumber = false;
    };

    plugins.gitsigns = {
      enable = true;
    };

    keymaps = [
      {
        mode = "i";
        key = "jj";
        action = "<Esc>";
      }
    ];
  };
}
