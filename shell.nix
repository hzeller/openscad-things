# This is a nix-shell for use with the nix package manager.
# If you have nix installed, you may simply run `nix-shell`
# in this repo, and have all dependencies ready in the new shell.

{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = with pkgs;
    [
      openscad
      openscad-lsp
      pstoedit

      # inspection
      meshlab

      # CAM
      prusa-slicer  
      orca-slicer
      #lightburn  # requires unfree
    ];
    shellHook = ''
       unset QT_PLUGIN_PATH   # lightburn workaround
       export WEBKIT_DISABLE_DMABUF_RENDERER=1  # orca-slicer work-around
    '';
}
