{ lib, pkgs, ... }:

{
  programs.thunderbird = {
    enable = true;
    profiles = {
      default = {
        isDefault = true;
      };
    };
    settings = {
      "mail.identity.default.reply_on_top" = 1;
      "mail.identity.default.sig_bottom" = false;
    };
  };

  accounts.email.accounts."me@ifa.codes" = {
    primary = true;
    address = "me@ifa.codes";
    realName = "Aoife Bradley";
    userName = "me@ifa.codes";
    imap = {
      host = "mailserver.purelymail.com";
      port = 993;
      tls.enable = true;
    };
    smtp = {
      host = "mailserver.purelymail.com";
      port = 465;
      tls.enable = true;
    };
    thunderbird = {
      enable = true;
      profiles = [ "default" ];
    };
  };
}
