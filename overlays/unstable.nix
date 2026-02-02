{ pkgs-unstable, pkgs-master }:
final: prev: {
  unstable = pkgs-unstable;
  master = pkgs-master;
}
