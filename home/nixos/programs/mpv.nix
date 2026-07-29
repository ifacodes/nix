{ ... }:

{

  programs.mpv = {
    enable = true;
    config = {
      ytdl-format = "bestvideo+bestaudio";
    };
  };

}
