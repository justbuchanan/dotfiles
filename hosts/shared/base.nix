# Some basic settings I want on all my nix systems. It gets imported by each
# system's configuration.nix.
{
  config,
  pkgs,
  inputs,
  ...
}:

{
  # Nix settings
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  programs.zsh.enable = true;

  # TODO: needed?
  security.polkit.enable = true;

  services.tailscale = {
    enable = true;
    extraSetFlags = [ "--ssh" ];
  };

  services.resolved.enable = true;
  networking.networkmanager.dns = "systemd-resolved";

  networking.firewall = {
    enable = true;
    allowPing = true;
  };

  environment.systemPackages = with pkgs; [
    btop
    busybox
    cachix
    colordiff
    cryptsetup
    curlFull
    dmidecode
    fast-cli
    git
    gnumake
    go
    home-manager
    htop
    inetutils
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    inxi
    jq
    mtr
    ncdu
    neofetch
    nix-index
    nmap
    openssl
    openssl.dev
    pkg-config
    python313
    socat
    speedtest-cli
    sqlite
    sysstat
    tig
    tmux
    tree
    wget
    zip
  ];
}
