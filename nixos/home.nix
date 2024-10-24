{ config, pkgs, ... }:

{
    services.nextcloud-client = {
        enable = true;
        startInBackground = true;
    };

    services.gnome-keyring.enable = true;

    home.stateVersion = "24.05";
}
