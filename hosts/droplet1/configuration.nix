# for reference: https://github.com/nix-community/nixos-anywhere-examples/blob/main/flake.nix
{
  config,
  lib,
  pkgs,
  inputs,
  modulesPath,
  ...
}:

{
  imports = [
    # from nixos-anywhere-examples
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    ./hardware-configuration.nix
    ../shared/base.nix
    ../shared/prometheus-exporter.nix
    ../shared/msmtp.nix
    ./webserver.nix
    ./authelia.nix
  ];

  # Configure agenix - this is the keyfile for decrypting secrets
  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  # Gmail token is viewable by users in the gmail-token-access group
  users.groups.gmail-token-access = { };
  age.secrets.buchanan-smarthome-gmail-token = {
    file = ../../secrets/buchanan-smarthome-gmail-token.age;
    owner = "root";
    group = "gmail-token-access";
    mode = "0440";
  };

  networking.hostName = "droplet1";

  # TODO: get rid of docker since webserver.nix uses podman?
  virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.justin = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel" # Enable 'sudo' for the user.
      "docker"
      "gmail-token-access" # allow reading gmail token secret
    ];
  };
  users.users.root.shell = pkgs.zsh;

  environment.systemPackages = [
    (pkgs.callPackage ../../packages/gmail-send.nix { inherit config; })
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    # framework pub key
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDkuyGPOZqQulvy1LzD6Mxxh6RIKoRxXBvgnT4VTDUWh9GlnoAaH3LZvIIs0QWPHycKeg+U0aHv78BJh3zASZrpuj3oBdgItC8vSbzb4ApS1N89i03V6ndrJpBjwPKS6SRFhWmUIxsZffTkPYhZiLRhQvzek/obyyfvQVSODcbOfWR3bIkgULDD1DxcM5I+YGVNVAWDgYpP1NpMG4AgEvGtkYxJ8et/9xtiPX1+xW2D+q79wjvkgbGYEqCaLUBhOYdRPpMvAT9UKWW/nQjXH+4sz/cHNs9+1HT4jccNzLWgreEclf3Wm2tL/P46KRB5mK2MxD+E2dwvJr27CYTiBSPAoiHqIufJ3t9XtGpOwNrELgwWq5Y6/TLiggaNiaAPo1Cd0TG6RbotLxnkoKn4WrL78ATyayTQYvvkWt7wfaZSUBk1cmvPuz1vo8YFd5V8ti6tMT0ebwKtwyAeOmMyEEZJZcafQa3wvAl1adiloUMfR1ID26U/1XAShs4LU3czMT8= justbuchanan+framework_laptop@gmail.com"
    # desktop
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDLWMt2PD0SLElE+QP7+kOVTV7w6gU5ufKaHCnavzRJHVsBlTni6LDAzC/rksaSl099QN0Piot3x2dIGVcYpdr4Lsxz1sL86nw80jHiLYwPOsIuNgLuWUdBMMW0qhbP9agh6I7ZdF5DCwSJzJ6F1kYIF09Vs4+s4EVYzc495Pm5GEJTnjYtG9ndaH0k0GVV67VbZ1CjuMwN9/dw7rpC/tNFv2vwTmQyoQdDckAKmjn8yLm80BtGdnC+JAJzie9/Ve3AtOr4Y6qQvQdUQu5ujEdzUKiukGfanPH2aTLdDUP51CN7e3Nq8ufqFOKhKLyvwSlMTQWaSU5N+bxHBh+d2rVE+XRJKZZWTkiQxo/cnCoBRuS6vLs99tAmciC8Wphd65KzVEjuLpXhOU96kxJ9dHBSyubiMrzBDWJi/PoMWo6ypqU2RcKDuxT5K78ZOSZSq1qQKdPpJKEwUoCHBoMfjtylhFrryuLqEfFAV3Up1+hrnfI6J/LMjuFWXyN13yCCQhs= justbuchanan+srvbox@gmail.com"
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.hack
  ];

  programs.dconf.enable = true;

  services.openssh.enable = true;

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
  };

  # DONT TOUCH THIS
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
