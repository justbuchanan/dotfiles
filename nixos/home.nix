{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
  };

  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

  services.gnome-keyring.enable = true;

  home.stateVersion = "24.05";
}
