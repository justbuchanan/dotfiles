{
  config,
  pkgs,
  inputs,
  ...
}:
{
  # Gmail token is viewable by users in the gmail-token-access group
  users.groups.gmail-token-access = { };
  age.secrets.buchanan-smarthome-gmail-token = {
    file = ../../secrets/buchanan-smarthome-gmail-token.age;
    owner = "root";
    group = "gmail-token-access";
    mode = "0440";
  };

  environment.systemPackages = [
    (pkgs.callPackage ../../packages/gmail-send.nix { inherit config; })
  ];

  programs.msmtp = {
    enable = true;
    accounts.default = {
      auth = "on";
      tls = "on";
      tls_trust_file = "/etc/ssl/certs/ca-certificates.crt";

      host = "smtp.gmail.com";
      port = "587";
      from = "buchanan.smarthome@gmail.com";
      user = "buchanan.smarthome@gmail.com";
      passwordeval = "cat ${config.age.secrets.buchanan-smarthome-gmail-token.path}";
    };
  };
}
