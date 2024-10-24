{ config, pkgs, ... }:

{
    services.nextcloud-client = {
        enable = true;
        startInBackground = true;
    };

    home.stateVersion = "24.05";
}
