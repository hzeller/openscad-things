{ pkgs ? import <nixpkgs> {} }:
let
  # for manually sending gcode
  gcode-cli = pkgs.stdenv.mkDerivation rec {
    name = "gcode-cli";
    src = pkgs.fetchFromGitHub {
      owner = "hzeller";
      repo = "gcode-cli";
      rev = "v0.9";
      hash = "sha256-L9hUleslnTd5LWm2ZgkgkiKq/UTQP3CuaorAkiKXoPk=";
    };
    buildPhase = "make";
    installPhase = "mkdir -p $out/bin; install gcode-cli $out/bin";
  };
in
pkgs.mkShell {
  buildInputs = with pkgs;
    [
      openscad-unstable
      openscad-lsp
      pstoedit
      gcode-cli

      # inspection
      #meshlab

      # CAM
      prusa-slicer
      #orca-slicer
      #lightburn  # requires unfree
    ];
    shellHook = ''
       unset QT_PLUGIN_PATH   # lightburn workaround
       export WEBKIT_DISABLE_DMABUF_RENDERER=1  # orca-slicer work-around
    '';
}
