{ pkgs, ... }:

{
  # Same setup as koitar: extensions and settings are managed in the app.
  # For remoting into koitar, install "Open Remote - SSH"
  # (jeanp413.open-remote-ssh) from the extensions panel; Microsoft's
  # Remote-SSH refuses to run in VSCodium.
  programs.vscodium = {
    enable = true;
    package = pkgs.vscodium;
    mutableExtensionsDir = true;
  };
}
