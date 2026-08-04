{ ... }:

{
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # NOTE: these keys must be quoted. Unquoted `default.clock.rate` is Nix
    # attribute nesting and serialises to {"default":{"clock":{"rate":...}}},
    # which PipeWire ignores — it wants flat dotted keys.
    extraConfig.pipewire."92-low-latency" = {
      context.properties = {
        "default.clock.rate" = 48000;
        "default.clock.allowed-rates" = [ 44100 48000 96000 ];
        "default.clock.quantum" = 192;
        "default.clock.min-quantum" = 64;
        "default.clock.max-quantum" = 2048;

        # `quantum` above is only a fallback — clients that request their own
        # latency (Chromium asks for 480) pull the graph elsewhere. Uncomment
        # to pin the graph at 192 regardless of what clients ask for.
        # "default.clock.force-quantum" = 192;
      };
    };

    # Scarlett 4i4 virtual sinks/sources
    # Outputs: stereo pairs + mono per channel
    # Inputs:  stereo pairs + mono per channel
    extraConfig.pipewire."10-scarlett-virtual" = {
      "context.modules" = [

        # ── Output Stereo Pairs ────────────────────────────────────────────────
        {
          name = "libpipewire-module-loopback";
          args = {
            "capture.props" = {
              "node.name"        = "scarlett.out.12";
              "node.description" = "Scarlett Output 1-2";
              "media.class"      = "Audio/Sink";
              "audio.channels"   = 2;
              "audio.position"   = [ "FL" "FR" ];
            };
            "playback.props" = {
              "node.name"         = "scarlett.out.12.play";
              "target.object"     = "alsa_output.usb-Focusrite_Scarlett_4i4_USB_D8Z74EC1B22469-00.pro-output-0";
              "audio.channels"    = 2;
              "audio.position"    = [ "AUX0" "AUX1" ];
              "stream.dont-remix" = true;
              "node.passive"      = true;
            };
          };
        }
        {
          name = "libpipewire-module-loopback";
          args = {
            "capture.props" = {
              "node.name"        = "scarlett.out.34";
              "node.description" = "Scarlett Output 3-4";
              "media.class"      = "Audio/Sink";
              "audio.channels"   = 2;
              "audio.position"   = [ "FL" "FR" ];
            };
            "playback.props" = {
              "node.name"         = "scarlett.out.34.play";
              "target.object"     = "alsa_output.usb-Focusrite_Scarlett_4i4_USB_D8Z74EC1B22469-00.pro-output-0";
              "audio.channels"    = 2;
              "audio.position"    = [ "AUX2" "AUX3" ];
              "stream.dont-remix" = true;
              "node.passive"      = true;
            };
          };
        }

        # ── Output Mono ────────────────────────────────────────────────────────
        {
          name = "libpipewire-module-loopback";
          args = {
            "capture.props" = {
              "node.name"        = "scarlett.out.1";
              "node.description" = "Scarlett Output 1";
              "media.class"      = "Audio/Sink";
              "audio.channels"   = 1;
              "audio.position"   = [ "MONO" ];
            };
            "playback.props" = {
              "node.name"         = "scarlett.out.1.play";
              "target.object"     = "alsa_output.usb-Focusrite_Scarlett_4i4_USB_D8Z74EC1B22469-00.pro-output-0";
              "audio.channels"    = 1;
              "audio.position"    = [ "AUX0" ];
              "stream.dont-remix" = true;
              "node.passive"      = true;
            };
          };
        }
        {
          name = "libpipewire-module-loopback";
          args = {
            "capture.props" = {
              "node.name"        = "scarlett.out.2";
              "node.description" = "Scarlett Output 2";
              "media.class"      = "Audio/Sink";
              "audio.channels"   = 1;
              "audio.position"   = [ "MONO" ];
            };
            "playback.props" = {
              "node.name"         = "scarlett.out.2.play";
              "target.object"     = "alsa_output.usb-Focusrite_Scarlett_4i4_USB_D8Z74EC1B22469-00.pro-output-0";
              "audio.channels"    = 1;
              "audio.position"    = [ "AUX1" ];
              "stream.dont-remix" = true;
              "node.passive"      = true;
            };
          };
        }
        {
          name = "libpipewire-module-loopback";
          args = {
            "capture.props" = {
              "node.name"        = "scarlett.out.3";
              "node.description" = "Scarlett Output 3";
              "media.class"      = "Audio/Sink";
              "audio.channels"   = 1;
              "audio.position"   = [ "MONO" ];
            };
            "playback.props" = {
              "node.name"         = "scarlett.out.3.play";
              "target.object"     = "alsa_output.usb-Focusrite_Scarlett_4i4_USB_D8Z74EC1B22469-00.pro-output-0";
              "audio.channels"    = 1;
              "audio.position"    = [ "AUX2" ];
              "stream.dont-remix" = true;
              "node.passive"      = true;
            };
          };
        }
        {
          name = "libpipewire-module-loopback";
          args = {
            "capture.props" = {
              "node.name"        = "scarlett.out.4";
              "node.description" = "Scarlett Output 4";
              "media.class"      = "Audio/Sink";
              "audio.channels"   = 1;
              "audio.position"   = [ "MONO" ];
            };
            "playback.props" = {
              "node.name"         = "scarlett.out.4.play";
              "target.object"     = "alsa_output.usb-Focusrite_Scarlett_4i4_USB_D8Z74EC1B22469-00.pro-output-0";
              "audio.channels"    = 1;
              "audio.position"    = [ "AUX3" ];
              "stream.dont-remix" = true;
              "node.passive"      = true;
            };
          };
        }

        # ── Input Stereo Pairs ─────────────────────────────────────────────────
        {
          name = "libpipewire-module-loopback";
          args = {
            "capture.props" = {
              "node.name"         = "scarlett.in.12.cap";
              "target.object"     = "alsa_input.usb-Focusrite_Scarlett_4i4_USB_D8Z74EC1B22469-00.pro-input-0";
              "audio.channels"    = 2;
              "audio.position"    = [ "AUX0" "AUX1" ];
              "stream.dont-remix" = true;
              "node.passive"      = true;
            };
            "playback.props" = {
              "node.name"        = "scarlett.in.12";
              "node.description" = "Scarlett Input 1-2";
              "media.class"      = "Audio/Source";
              "audio.channels"   = 2;
              "audio.position"   = [ "FL" "FR" ];
            };
          };
        }
        {
          name = "libpipewire-module-loopback";
          args = {
            "capture.props" = {
              "node.name"         = "scarlett.in.34.cap";
              "target.object"     = "alsa_input.usb-Focusrite_Scarlett_4i4_USB_D8Z74EC1B22469-00.pro-input-0";
              "audio.channels"    = 2;
              "audio.position"    = [ "AUX2" "AUX3" ];
              "stream.dont-remix" = true;
              "node.passive"      = true;
            };
            "playback.props" = {
              "node.name"        = "scarlett.in.34";
              "node.description" = "Scarlett Input 3-4";
              "media.class"      = "Audio/Source";
              "audio.channels"   = 2;
              "audio.position"   = [ "FL" "FR" ];
            };
          };
        }

        # ── Input Mono ─────────────────────────────────────────────────────────
        {
          name = "libpipewire-module-loopback";
          args = {
            "capture.props" = {
              "node.name"         = "scarlett.in.1.cap";
              "target.object"     = "alsa_input.usb-Focusrite_Scarlett_4i4_USB_D8Z74EC1B22469-00.pro-input-0";
              "audio.channels"    = 1;
              "audio.position"    = [ "AUX0" ];
              "stream.dont-remix" = true;
              "node.passive"      = true;
            };
            "playback.props" = {
              "node.name"        = "scarlett.in.1";
              "node.description" = "Scarlett Input 1";
              "media.class"      = "Audio/Source";
              "audio.channels"   = 1;
              "audio.position"   = [ "MONO" ];
            };
          };
        }
        {
          name = "libpipewire-module-loopback";
          args = {
            "capture.props" = {
              "node.name"         = "scarlett.in.2.cap";
              "target.object"     = "alsa_input.usb-Focusrite_Scarlett_4i4_USB_D8Z74EC1B22469-00.pro-input-0";
              "audio.channels"    = 1;
              "audio.position"    = [ "AUX1" ];
              "stream.dont-remix" = true;
              "node.passive"      = true;
            };
            "playback.props" = {
              "node.name"        = "scarlett.in.2";
              "node.description" = "Scarlett Input 2";
              "media.class"      = "Audio/Source";
              "audio.channels"   = 1;
              "audio.position"   = [ "MONO" ];
            };
          };
        }
        {
          name = "libpipewire-module-loopback";
          args = {
            "capture.props" = {
              "node.name"         = "scarlett.in.3.cap";
              "target.object"     = "alsa_input.usb-Focusrite_Scarlett_4i4_USB_D8Z74EC1B22469-00.pro-input-0";
              "audio.channels"    = 1;
              "audio.position"    = [ "AUX2" ];
              "stream.dont-remix" = true;
              "node.passive"      = true;
            };
            "playback.props" = {
              "node.name"        = "scarlett.in.3";
              "node.description" = "Scarlett Input 3";
              "media.class"      = "Audio/Source";
              "audio.channels"   = 1;
              "audio.position"   = [ "MONO" ];
            };
          };
        }
        {
          name = "libpipewire-module-loopback";
          args = {
            "capture.props" = {
              "node.name"         = "scarlett.in.4.cap";
              "target.object"     = "alsa_input.usb-Focusrite_Scarlett_4i4_USB_D8Z74EC1B22469-00.pro-input-0";
              "audio.channels"    = 1;
              "audio.position"    = [ "AUX3" ];
              "stream.dont-remix" = true;
              "node.passive"      = true;
            };
            "playback.props" = {
              "node.name"        = "scarlett.in.4";
              "node.description" = "Scarlett Input 4";
              "media.class"      = "Audio/Source";
              "audio.channels"   = 1;
              "audio.position"   = [ "MONO" ];
            };
          };
        }

      ];
    };
  };
}
