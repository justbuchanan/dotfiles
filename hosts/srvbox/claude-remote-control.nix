{ lib, pkgs, ... }:
{
  # Lets the Claude phone app start Claude Code sessions in ~/src/justin.
  systemd.user.services.claude-remote-control = {
    description = "Claude Code Remote Control server for ~/src/justin";
    wantedBy = [ "default.target" ];
    unitConfig.ConditionUser = "justin";
    path = [
      "/run/wrappers"
      "/home/justin/.nix-profile"
      "/etc/profiles/per-user/justin"
      "/run/current-system/sw"
    ];
    serviceConfig = {
      WorkingDirectory = "%h/src/justin";
      ExecStart = "${lib.getExe pkgs.claude-code} remote-control --name src-justin";
      # It exits after ~10 minutes without network.
      Restart = "always";
      RestartSec = "30s";
    };
  };

  # Start the user manager at boot so the server runs without a login.
  users.users.justin.linger = true;
}
