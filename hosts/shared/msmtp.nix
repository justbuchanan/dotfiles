{
  config,
  pkgs,
  inputs,
  ...
}:
{
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
