{
  description = "My NixOS config";

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
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };

  outputs =
    {
      home-manager,
      nixpkgs,
      nixpkgs-unstable,
      nixpkgs-master,
      treefmt-nix,
      flake-utils,
      ...
    }@inputs:
    let
      defaultUserName = "brock";
      allowUnfree = true;
      lib = nixpkgs.lib;
      mkOverlays = system: [
        (import ./overlays/unstable.nix (
          inputs
          // {
            inherit
              nixpkgs-master
              nixpkgs-unstable
              system
              allowUnfree
              ;
          }
        ))
      ];
      systems = [
        rec {
          hostName = "${userName}-thinkpad";
          system = "x86_64-linux";
          userName = defaultUserName;
        }
        rec {
          hostName = "${userName}-desktop";
          system = "x86_64-linux";
          userName = defaultUserName;
        }
      ];
      createSystem =
        {
          hostName,
          system,
          userName ? defaultUserName,
          ...
        }:
        {
          name = hostName;
          value = lib.nixosSystem {
            inherit system;
            modules = [
              (
                { allowUnfree, ... }:
                {
                  nixpkgs = {
                    overlays = mkOverlays system;
                    config = {
                      inherit allowUnfree;
                    };
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
              inherit allowUnfree userName;
              inherit hostName;
            };
          };
        };
      createHome =
        {
          hostName,
          system,
          userName ? defaultUserName,
          ...
        }:
        {
          name = "${userName}@${hostName}";
          value = home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs {
              inherit system;
              overlays = mkOverlays system;
              config = {
                inherit allowUnfree;
              };
            };
            modules = [
              ./homeConfig
            ];
            extraSpecialArgs = {
              inherit allowUnfree userName;
              inherit hostName;
            };
          };
        };
    in
    {
      nixosConfigurations = builtins.listToAttrs (lib.map createSystem systems);
      homeConfigurations = builtins.listToAttrs (lib.map createHome systems);
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          overlays = mkOverlays system;
          inherit system;
          config = {
            inherit allowUnfree;
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
        devShells = {
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

        formatter = treefmtEval.config.build.wrapper;
        packages = {
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
      }
    );
}
