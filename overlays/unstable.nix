{
  pkgs-unstable,
  pkgs-master,
  ...
}:
let
  unstable = final: prev: {
    unstable = pkgs-unstable;
    master = pkgs-master;
  };
in
[
  unstable
]
