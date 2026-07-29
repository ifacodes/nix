{ lib, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      init = {
        defaultBranch = "main";
      };
      user = {
        name = "Aoife Bradley";
        email = "me@ifa.codes";
        gpg = {
          format = "ssh";
        };
        "gpg \"ssh\"" = {
          program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
        };
        commit = {
          gpgsign = true;
        };
        user = {
          signingKey = "...";
        };
      };
    };
  };
}
