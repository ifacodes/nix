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
          program =
            if pkgs.stdenv.isDarwin
            then "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
            else "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
        };
        commit = {
          gpgsign = true;
        };
        user = {
          signingKey = "...";
        };
      };
    };
    lfs.enable = true;
  };
}
