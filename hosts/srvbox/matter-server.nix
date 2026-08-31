{ ... }:
{
  services.matter-server = {
    enable = true;
    port = 5580;
    openFirewall = false;
  };
}
