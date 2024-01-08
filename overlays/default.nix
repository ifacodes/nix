{ pkgs, rust-overlay, ... }: {

  modifications = final: prev: {
    overlays = [
      rust-overlay.overlays.default
    ];
  };
  
}
