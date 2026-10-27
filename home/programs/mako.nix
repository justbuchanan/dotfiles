{ pkgs, ... }:
{
  # colors and font come from stylix
  services.mako = {
    enable = true;
    settings = {
      anchor = "top-right";
      layer = "overlay";
      width = 380;
      height = 160;
      outer-margin = "8,12,0,0";
      margin = "6,0";
      padding = "12,14";
      border-size = 2;
      border-radius = 10;
      icons = true;
      max-icon-size = 48;
      icon-path = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark";
      default-timeout = 6000;
      max-visible = 4;
      sort = "-time";
      group-by = "app-name,summary";
      format = ''<b>%s</b>\n%b'';

      "grouped=true".format = ''<b>%s</b> <i>(%g)</i>\n%b'';
      "urgency=critical".default-timeout = 0;
      "mode=do-not-disturb".invisible = true;
    };
  };
}
