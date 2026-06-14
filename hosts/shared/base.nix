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
  # Periodically hardlink-dedupe the nix store. Runs `nix-store --optimise` on a
  # systemd timer (nix-optimise.timer). `dates` entries are systemd OnCalendar
  # specs in local time; the timer is Persistent, so a missed run (machine off)
  # fires after the next boot. Defaults to daily at 03:45.
  nix.optimise = {
    automatic = true;
    dates = [ "03:45" ];
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
  networking.nameservers = [
    "8.8.8.8"
    "8.8.4.4"
    "1.1.1.1"
    "9.9.9.9"
  ];

  environment.systemPackages = with pkgs; [
    btop
    busybox
    cachix
    colordiff
    cryptsetup
    curlFull
    dmidecode
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
