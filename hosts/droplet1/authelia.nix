{ config, pkgs, ... }:

{
  # Configure agenix secrets
  age.secrets = {
    droplet1-authelia-jwt-secret = {
      file = ../../secrets/droplet1-authelia-jwt-secret.age;
      owner = "authelia-main";
      group = "authelia-main";
    };
    droplet1-authelia-encryption-key = {
      file = ../../secrets/droplet1-authelia-encryption-key.age;
      owner = "authelia-main";
      group = "authelia-main";
    };
    droplet1-authelia-users = {
      file = ../../secrets/droplet1-authelia-users.age;
      owner = "authelia-main";
      group = "authelia-main";
    };
  };

  services.authelia.instances.main = {
    enable = true;

    secrets = {
      jwtSecretFile = config.age.secrets.droplet1-authelia-jwt-secret.path;
      storageEncryptionKeyFile = config.age.secrets.droplet1-authelia-encryption-key.path;
    };

    settings = {
      server.address = "127.0.0.1:9091";

      # using age, but could also use "/var/lib/authelia-main/users.yml"
      authentication_backend.file.path = config.age.secrets.droplet1-authelia-users.path;

      storage.local.path = "/var/lib/authelia-main/db.sqlite3";

      session = {
        name = "authelia_session";
        expiration = 3600; # 1 hour
        inactivity = 300; # 5 minutes
        domain = "justbuchanan.com";
      };

      notifier.filesystem.filename = "/var/lib/authelia-main/notification.txt";

      regulation = {
        max_retries = 3;
        find_time = 120;
        ban_time = 3600;
      };

      access_control = {
        default_policy = "one_factor";
        rules = [
          {
            domain = "*.justbuchanan.com";
            subject = "group:admins";
            policy = "one_factor";
          }
        ];
      };
    };
  };
}
