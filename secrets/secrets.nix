# To generate encrypted secrets (.age files)
# * cd to this directory
# * nix run github:ryantm/agenix -- -e droplet1-authelia-jwt-secret.age
# * type secret into editor that pops up and save
let
  # pub keys
  droplet1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKMrFAYD7bbkHKnnJ8DsDYpropw9N/OeIPl+8h27/ed1 root@droplet1";
  justin-srvbox = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAV1Opx5znTrZ2vsFCifxScZ7+2H3Z63KebGBoXGmvRs justin@srvbox";
in
{
  "droplet1-authelia-jwt-secret.age".publicKeys = [
    droplet1
    justin-srvbox
  ];
  "droplet1-authelia-encryption-key.age".publicKeys = [
    droplet1
    justin-srvbox
  ];
  "droplet1-authelia-users.age".publicKeys = [
    droplet1
    justin-srvbox
  ];
}
