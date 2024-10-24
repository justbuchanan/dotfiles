{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
  };

  programs.ssh.enable = true;

  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

  services.gnome-keyring.enable = true;

  home.stateVersion = "24.05";
}
