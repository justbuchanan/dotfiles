{ config, pkgs, ... }:

let
  lua-scripts = pkgs.fetchFromGitHub {
    owner = "darktable-org";
    repo = "lua-scripts";
    rev = "447980ddc43bdc0f93be1f06ce05b7fd98812b7b";
    sha256 = "sha256-NL/KFcpAaCdXHNrLnVxYpe4T+SfM2fXgueTKS+j9ffc=";
  };
in
{
  home.file = {
    ".config/darktable/luarc".text = ''
      require "tools/script_manager"
    '';

    ".config/darktable/lua".source = lua-scripts;
  };
}
