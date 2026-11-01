{ config, ... }:

# HTTPS for tailnet-only services. Their DNS records point at srvbox's tailscale
# IP, so Let's Encrypt can't reach them and certs need a DNS challenge. An nginx
# vhost opts in with: onlySSL = true; enableACME = true; acmeRoot = null;

{
  age.secrets.cloudflare-dns-token.file = ../../secrets/cloudflare-dns-token.age;

  security.acme = {
    acceptTerms = true;
    defaults = {
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      credentialFiles.CF_DNS_API_TOKEN_FILE = config.age.secrets.cloudflare-dns-token.path;
    };
  };

  # nginx binds all interfaces, this keeps 443 off the LAN.
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 443 ];
}
