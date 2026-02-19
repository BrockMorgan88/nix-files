{
  description = "A template that shows all standard flake outputs";

  # Inputs
  # https://nixos.org/manual/nix/unstable/command-ref/new-cli/nix3-flake.html#flake-inputs

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      home-manager,
      nixpkgs,
      nixpkgs-unstable,
      nixpkgs-master,
      treefmt-nix,
      ...
    }@inputs:
    let
      userName = "brock";
      unfreeAllowed = true;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = unfreeAllowed;
        };
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config = {
          allowUnfree = unfreeAllowed;
        };
      };
      pkgs-master = import nixpkgs-master {
        inherit system;
        config = {
          allowUnfree = unfreeAllowed;
        };
      };
      lib = nixpkgs.lib;
      overlays = [
        (import ./overlays/unstable.nix (
          inputs
          // {
            inherit pkgs-master pkgs-unstable;
          }
        ))
      ];
      systems = [
        "${userName}-thinkpad"
        "${userName}-desktop"
      ];
      createSystem = systemName: {
        name = systemName;
        value = lib.nixosSystem {
          inherit system;
          modules = [
            (
              { unfreeAllowed, ... }:
              {
                nixpkgs = {
                  inherit overlays;
                  config.allowUnfree = unfreeAllowed;
                };
              }
            )
            ./NixOSConfig
            home-manager.nixosModules.home-manager
            (
              { specialArgs, ... }:
              {
                home-manager = {
                  backupFileExtension = ".bak";
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.${userName} = import ./homeConfig;
                  extraSpecialArgs = specialArgs;
                };
              }
            )
          ];
          specialArgs = {
            inherit unfreeAllowed userName;
            hostName = systemName;
          };
        };
      };
      createHome = systemName: {
        name = "${userName}@${systemName}";
        value = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./homeConfig
          ];
          extraSpecialArgs = {
            inherit unfreeAllowed userName;
            hostName = systemName;
          };
        };
      };
      treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
      treefmt-write-config = pkgs.writeShellScriptBin "treefmt-write-config" ''
        cd "$(git rev-parse --show-toplevel)"
        cp ${treefmtEval.config.build.configFile} ./treefmt.toml
        chmod +w treefmt.toml
        # strip out Nix store prefix path from the config,
        # along with ruff-check (it just causes errors when trying to "format" in VSCode,
        # since it's a linter)
        sed -i -e 's,command.*/,command = ",' -e "/\[formatter\.ruff-check\]/,/^$/d" treefmt.toml
      '';
    in
    {
      nixosConfigurations = builtins.listToAttrs (lib.map createSystem systems);
      homeConfigurations = builtins.listToAttrs (lib.map createHome systems);

      devShells.x86_64-linux = {
        default = pkgs.mkShell {
          name = "devShell";
          packages = with pkgs; [
            man-pages
            man-pages-posix
            stdmanpages
            wev
          ];
        };
      };

      formatter.x86_64-linux = treefmtEval.config.build.wrapper;
      packages.x86_64-linux = {
        tools =
          pkgs.runCommand "tools"
            {
              passthru = {
                inherit treefmt-write-config;
              };
            }
            ''
              mkdir $out
            '';
      };
    };
}
