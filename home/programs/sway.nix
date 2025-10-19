{
  config,
  pkgs,
  inputs,
  ...
}:

{
  home.packages = with pkgs; [
    swayidle
    inputs.niri-autoname-workspaces.packages.${pkgs.system}.default
    # swaylock
    swayest-workstyle
    workstyle
  ];

  home.file = {
    ".config/sway".source = ../.config/sway;
    ".config/sworkstyle/config.toml".source = ../.config/sworkstyle/config.toml;
  };
}
