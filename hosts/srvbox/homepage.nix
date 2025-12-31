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

  # Enable homepage-dashboard service
  services.homepage-dashboard = {
    enable = true;
    allowedHosts = "localhost:8082,127.0.0.1:8082,homepage.justbuchanan.com";
  };

  # Declaratively symlink config files into the service's config directory
  systemd.tmpfiles.rules = [
    "L+ /var/lib/homepage-dashboard/settings.yaml - - - - ${./homepage/config/settings.yaml}"
    "L+ /var/lib/homepage-dashboard/services.yaml - - - - ${./homepage/config/services.yaml}"
    "L+ /var/lib/homepage-dashboard/widgets.yaml - - - - ${./homepage/config/widgets.yaml}"
    "L+ /var/lib/homepage-dashboard/docker.yaml - - - - ${./homepage/config/docker.yaml}"
  ];

  systemd.services.homepage-dashboard.serviceConfig.SupplementaryGroups = [ "homepage-token-access" ];
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

  # Docker proxy for monitoring srvbox containers
  virtualisation.oci-containers.containers = {
    dockerproxy = {
      image = "ghcr.io/tecnativa/docker-socket-proxy:latest";
      environment = {
        CONTAINERS = "1";
        SERVICES = "1";
        TASKS = "1";
        POST = "0";
      };
      ports = [ "127.0.0.1:2375:2375" ];
      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock:ro"
      ];
    };
  };
}
