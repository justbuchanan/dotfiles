# Server configs for Don't Starve Together game
{ ... }:
{
  # open up ports for don't starve together
  networking.firewall.allowedTCPPorts = [
    10998
    10999
    11000
  ];
  networking.firewall.allowedUDPPorts = [
    10998
    10999
    11000
  ];
}
