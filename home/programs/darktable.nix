{ config, pkgs, ... }:

let
  lua-scripts = pkgs.fetchFromGitHub {
    owner = "darktable-org";
    repo = "lua-scripts";
    rev = "master";
    sha256 = "sha256-Qt3DkmNH/ZWY3uI8UvhSM4dDt7KDQlJqOnPmsySGGwU=";
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
