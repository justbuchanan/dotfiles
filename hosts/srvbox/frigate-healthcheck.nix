{
  config,
  pkgs,
  ...
}:

let
  notifyEmail = "justbuchanan@gmail.com";
in
{
  # Catches Frigate being up but blind (dead detector, restart loop), which the
  # HA camera-offline automation can't see. Emails once after two failed checks
  # in a row, and again on recovery.
  systemd.services.frigate-healthcheck = {
    description = "Check that Frigate is up and detecting";
    path = [
      pkgs.curl
      pkgs.jq
      pkgs.msmtp
      config.systemd.package
    ];
    serviceConfig = {
      Type = "oneshot";
      DynamicUser = true;
      StateDirectory = "frigate-healthcheck";
      SupplementaryGroups = [
        "gmail-token-access"
        "systemd-journal"
      ];
    };
    script = ''
      state=$STATE_DIRECTORY
      problems=()

      status=$(systemctl is-active frigate || true)
      [ "$status" = active ] || problems+=("frigate.service is $status")

      if stats=$(curl -sf --max-time 10 http://127.0.0.1:5000/api/stats); then
        detectors=$(jq -r '.detectors | to_entries[] | "\(.key) \(.value.pid)"' <<<"$stats")
        [ -n "$detectors" ] || problems+=("Frigate reports no detectors")
        while read -r name pid; do
          [ -n "$name" ] || continue
          [ "$pid" != null ] && [ -d "/proc/$pid" ] || problems+=("detector $name is not running")
        done <<<"$detectors"
      else
        problems+=("Frigate API is not responding")
      fi

      # NRestarts counts only automatic restarts, and resets on a manual one.
      restarts=$(systemctl show frigate -p NRestarts --value)
      last=$(cat "$state/restarts" 2>/dev/null || echo "$restarts")
      echo "$restarts" >"$state/restarts"
      if [ "$restarts" -gt "$last" ]; then
        problems+=("frigate restarted itself $((restarts - last)) times since the last check")
      fi

      fails=$(cat "$state/fails" 2>/dev/null || echo 0)
      if [ ''${#problems[@]} -gt 0 ]; then
        fails=$((fails + 1))
        printf '%s\n' "''${problems[@]}"
      else
        fails=0
      fi
      echo "$fails" >"$state/fails"

      send() {
        {
          printf 'To: %s\nSubject: %s\n\n' ${notifyEmail} "$1"
          printf '%s\n' "''${problems[@]}"
          printf '\nRecent Frigate log:\n\n'
          journalctl -u frigate -n 50 --no-pager -o short-iso
        } | msmtp -a default -t
      }

      if [ "$fails" -ge 2 ] && [ ! -e "$state/alerted" ]; then
        send "Frigate is unhealthy on ${config.networking.hostName}"
        touch "$state/alerted"
      elif [ "$fails" -eq 0 ] && [ -e "$state/alerted" ]; then
        problems=("Frigate is healthy again.")
        send "Frigate recovered on ${config.networking.hostName}"
        rm "$state/alerted"
      fi
    '';
  };

  systemd.timers.frigate-healthcheck = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "10min";
      OnUnitActiveSec = "5min";
    };
  };
}
