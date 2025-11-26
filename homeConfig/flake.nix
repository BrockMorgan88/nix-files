{
  description = "Home Manager configuration of brock";

  inputs = 
  let
    mainflake = import ./../flake.nix;
    mainflakeinputs = mainflake.inputs;
  in {
    nixpkgs = mainflakeinputs.nixpkgs;
    home-manager = mainflakeinputs.home-manager;
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."brock" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = ".bak";
        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
