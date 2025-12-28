{
  pkgs,
  pkgs-unstable,
  pkgs-master,
  lib,
  ...
}@args:
let
  unstable = final: prev: {
    unstable = pkgs-unstable;
    master = pkgs-master;
  };
in
[
  unstable
]