{ pkgs ? import <nixpkgs> {} }:
let
  envname = "platformio-fhs";
  mypython = pkgs.python3.withPackages (ps: with ps; [ pkgs.platformio ]);
in
(pkgs.buildFHSEnv {
  name = envname;
  targetPkgs = pkgs: (with pkgs; [
    platformio-core
    mypython
    openocd
  ]);
  runScript = "env LD_LIBRARY_PATH= bash";
}).env