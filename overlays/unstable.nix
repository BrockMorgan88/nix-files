{
  nixpkgs-unstable,
  nixpkgs-master,
  system,
  allowUnfree,
  allowUnfreePredicate,
  ...
}:
final: prev: {
  unstable = import nixpkgs-unstable {
    inherit system;
    config = {
      inherit allowUnfree allowUnfreePredicate;
    };
  };
  master = import nixpkgs-master {
    inherit system;
    config = {
      inherit allowUnfree allowUnfreePredicate;
    };
  };
}
