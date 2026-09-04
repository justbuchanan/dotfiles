# Matter controller for HA. The two KP125M plugs speak TP-Link's TPAP
# transport, which python-kasa cannot -- Matter is the only way in.
{ pkgs, ... }:
{
  services.matter-server = {
    enable = true;
    port = 5580;
    openFirewall = false;

    # Otherwise the server picks a container bridge ("Using 'None' as primary
    # interface") and advertises _matter._tcp only on veth0/podman0, so
    # commissioning timed out.
    extraArgs.primary-interface = "enp5s0";

    # Startup fetches PAA root certs from the public Matter DCL and parses each
    # one unguarded; one entry has malformed ASN.1, so a ValueError escaped
    # server.start() and the controller never bound -- with systemd still
    # calling the unit active, because aiorun swallows the error.
    package = pkgs.python-matter-server.overridePythonAttrs (old: {
      patches = (old.patches or [ ]) ++ [ ./matter-server/skip-malformed-paa-cert.patch ];
    });
  };
}
