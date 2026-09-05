{
  config,
  pkgs,
  lib,
  ...
}:
{
  users.groups.homepage-token-access = { };

  # Define secrets for homepage API keys
  age.secrets.homepage-home-assistant-key = {
    file = ../../secrets/homepage-home-assistant-key.age;
    owner = "root";
    group = "homepage-token-access";
    mode = "0440";
  };
  age.secrets.homepage-jellyfin-key = {
    file = ../../secrets/homepage-jellyfin-key.age;
    owner = "root";
    group = "homepage-token-access";
    mode = "0440";
  };
  age.secrets.homepage-nextcloud-key = {
    file = ../../secrets/homepage-nextcloud-key.age;
    owner = "root";
    group = "homepage-token-access";
    mode = "0440";
  };
  age.secrets.homepage-grafana-password = {
    file = ../../secrets/grafana-admin-password.age;
    owner = "root";
    group = "homepage-token-access";
    mode = "0440";
  };

  # Enable homepage-dashboard service.
  # Listen on 8083 (module default is 8082) because Frigate's jsmpeg live-view
  # output binds 127.0.0.1:8082 and homepage was squatting on it (0.0.0.0:8082),
  # causing frigate.output to crash-loop. Caddy's homepage vhost on droplet2
  # proxies to srvbox:8083 to match.
  services.homepage-dashboard = {
    enable = true;
    listenPort = 8083;
    allowedHosts = "localhost:8083,127.0.0.1:8083,homepage.justbuchanan.com";
  };

  # Declaratively symlink config files into the service's config directory.
  # homepage seeds a skeleton for any file missing from HOMEPAGE_CONFIG_DIR and
  # process.exit(1)s if that write fails, so the dir must stay writable -- hence
  # pointing it at StateDirectory below. kubernetes.yaml / proxmox.yaml /
  # bookmarks.yaml / custom.css / custom.js are inert; they're pinned here only
  # so the seeded skeletons don't drift into state.
  systemd.tmpfiles.rules = [
    "L+ /var/lib/homepage-dashboard/settings.yaml - - - - ${./homepage/config/settings.yaml}"
    "L+ /var/lib/homepage-dashboard/services.yaml - - - - ${./homepage/config/services.yaml}"
    "L+ /var/lib/homepage-dashboard/widgets.yaml - - - - ${./homepage/config/widgets.yaml}"
    "L+ /var/lib/homepage-dashboard/kubernetes.yaml - - - - ${./homepage/config/kubernetes.yaml}"
    "L+ /var/lib/homepage-dashboard/proxmox.yaml - - - - ${./homepage/config/proxmox.yaml}"
    "L+ /var/lib/homepage-dashboard/bookmarks.yaml - - - - ${./homepage/config/bookmarks.yaml}"
    "L+ /var/lib/homepage-dashboard/custom.css - - - - ${./homepage/config/custom.css}"
    "L+ /var/lib/homepage-dashboard/custom.js - - - - ${./homepage/config/custom.js}"

    # Drop the symlink left by the old docker.yaml rule. Once its store path is
    # GC'd homepage sees a dangling link, tries to seed a skeleton through it
    # and dies on EROFS. Safe to delete this line later.
    "r /var/lib/homepage-dashboard/docker.yaml"
  ];

  systemd.services.homepage-dashboard.serviceConfig.SupplementaryGroups = [ "homepage-token-access" ];

  # The resources widget reads host CPU from /proc/stat, but the module's
  # default ProcSubset=pid mounts /proc with subset=pid and hides the
  # system-wide files, so CPU always reads 0/null (memory still works because
  # it comes from the sysinfo() syscall, not /proc). Expose the full /proc.
  systemd.services.homepage-dashboard.serviceConfig.ProcSubset = lib.mkForce "all";
  systemd.services.homepage-dashboard.environment.HOMEPAGE_CONFIG_DIR =
    lib.mkForce "/var/lib/homepage-dashboard";

  # Use a pre-start script to read secrets from agenix and write them to a an
  # environment file, which systemd will read and make accessible to the
  # service.
  systemd.services.homepage-dashboard.serviceConfig.RuntimeDirectory = "homepage-dashboard";
  systemd.services.homepage-dashboard.preStart = ''
        cat > /run/homepage-dashboard/.env <<EOF
    HOMEPAGE_VAR_HOME_ASSISTANT_KEY=$(cat ${config.age.secrets.homepage-home-assistant-key.path})
    HOMEPAGE_VAR_JELLYFIN_KEY=$(cat ${config.age.secrets.homepage-jellyfin-key.path})
    HOMEPAGE_VAR_NEXTCLOUD_KEY=$(cat ${config.age.secrets.homepage-nextcloud-key.path})
    HOMEPAGE_VAR_GRAFANA_PASS=$(cat ${config.age.secrets.homepage-grafana-password.path})
    HOMEPAGE_VAR_GRAFANA_USER=admin
    EOF
  '';
  systemd.services.homepage-dashboard.serviceConfig.EnvironmentFile =
    lib.mkForce "-/run/homepage-dashboard/.env";
}
