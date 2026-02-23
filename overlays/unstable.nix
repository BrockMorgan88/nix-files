{
  nixpkgs-unstable,
  nixpkgs-master,
  system,
  allowUnfree,
  ...
}:
final: prev: {
  unstable = import nixpkgs-unstable {
    inherit system;
    config = {
      inherit allowUnfree;
    };
  };
  master = import nixpkgs-master {
    inherit system;
    config = {
      inherit allowUnfree;
    };
  };
}
