{ pkgs, lib, ... }: {

  home.username = "ifa";

  programs.git.settings.user = {
    name = "Aoife Bradley";
    email = "me@ifa.codes";
  };

}
