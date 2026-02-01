# To generate encrypted secrets (.age files)
# * cd to this directory
# * nix run github:ryantm/agenix -- -e droplet1-authelia-jwt-secret.age
# * type secret into editor that pops up and save
#
# To generate a new ed25519 key for your user:
#   ssh-keygen -t ed25519 -C "user@host"
#
# If you change any keys, you need to rekey with:
#   cd <this directory>
#   agenix --rekey
let
  # pub keys
  droplet1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKMrFAYD7bbkHKnnJ8DsDYpropw9N/OeIPl+8h27/ed1 root@droplet1";
  justin-srvbox = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICqqJamlTBKWzwcbTBJMVEezhaEc0XlACLaPcB7mWG/4 justin@srvbox";
  justin-framework = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO4tJlxrvlz/mhLa6AZ8N0y8cezN1vQrkuA8Dpv7kr+6 justin@framework";
  root-srvbox = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK6yzd3pyDOXQSkn8oeQCfpZG11vYkw1skzeBBhLJvEW root@srvbox";
  root-framework = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK/0270WbIpuqQu1zozBzNBQr/BWCk/c/aRcYiexNtP/ root@framework";
in
{
  "droplet1-authelia-jwt-secret.age".publicKeys = [
    droplet1
    justin-srvbox
    justin-framework
  ];
  "droplet1-authelia-encryption-key.age".publicKeys = [
    droplet1
    justin-srvbox
    justin-framework
  ];
  "droplet1-authelia-users.age".publicKeys = [
    droplet1
    justin-srvbox
    justin-framework
  ];
  "buchanan-smarthome-gmail-token.age".publicKeys = [
    droplet1
    justin-srvbox
    justin-framework
    root-srvbox
    root-framework
  ];
  "grafana-admin-password.age".publicKeys = [
    justin-srvbox
    justin-framework
    root-srvbox
  ];
  "grafana-secret-key.age".publicKeys = [
    justin-srvbox
    justin-framework
    root-srvbox
  ];
  "backblaze-b2-credentials.age".publicKeys = [
    justin-srvbox
    justin-framework
    root-srvbox
  ];
  "homepage-home-assistant-key.age".publicKeys = [
    justin-srvbox
    justin-framework
    root-srvbox
  ];
  "homepage-jellyfin-key.age".publicKeys = [
    justin-srvbox
    justin-framework
    root-srvbox
  ];
  "homepage-nextcloud-key.age".publicKeys = [
    justin-srvbox
    justin-framework
    root-srvbox
  ];
  "factorio-server-settings.age".publicKeys = [
    justin-srvbox
    justin-framework
    root-srvbox
  ];
}
