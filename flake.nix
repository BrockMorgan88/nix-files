{
  description = "A template that shows all standard flake outputs";

  # Inputs
  # https://nixos.org/manual/nix/unstable/command-ref/new-cli/nix3-flake.html#flake-inputs

  # The flake in the current directory.
  # inputs.currentDir.url = ".";

  # A flake in some other directory.
  # inputs.otherDir.url = "/home/alice/src/patchelf";

  # A flake in some absolute path
  # inputs.otherDir.url = "path:/home/alice/src/patchelf";

  # The nixpkgs entry in the flake registry.
  # inputs.nixpkgsRegistry.url = "nixpkgs";

  # # The nixpkgs entry in the flake registry, overriding it to use a specific Git revision.

  # inputs.nixpkgsRegistryOverride.url = "nixpkgs/a3a3dda3bacf61e8a39258a0ed9c924eeca8e293";
  # The master branch of the NixOS/nixpkgs repository on GitHub.

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
  };

  # The nixos-20.09 branch of the NixOS/nixpkgs repository on GitHub.
  # inputs.nixpkgsGitHubBranch.url = "github:NixOS/nixpkgs/nixos-20.09";

  # A specific revision of the NixOS/nixpkgs repository on GitHub.
  # inputs.nixpkgsGitHubRevision.url = "github:NixOS/nixpkgs/a3a3dda3bacf61e8a39258a0ed9c924eeca8e293";

  # # A flake in a subdirectory of a GitHub repository.
  # inputs.nixpkgsGitHubDir.url = "github:edolstra/nix-warez?dir=blender";

  # # A git repository.
  # inputs.gitRepo.url = "git+https://github.com/NixOS/patchelf";

  # # A specific branch of a Git repository.
  # inputs.gitRepoBranch.url = "git+https://github.com/NixOS/patchelf?ref=master";

  # # A specific revision of a Git repository.
  # inputs.gitRepoRev.url = "git+https://github.com/NixOS/patchelf?ref=master&rev=f34751b88bd07d7f44f5cd3200fb4122bf916c7e";

  # # A tarball flake
  # inputs.tarFlake.url = "https://github.com/NixOS/patchelf/archive/master.tar.gz";

  # A GitHub repository.
  # inputs.import-cargo = {
  #   type = "github";
  #   owner = "edolstra";
  #   repo = "import-cargo";
  # };

  # Inputs as attrsets.
  # An indirection through the flake registry.
  # inputs.nixpkgsIndirect = {
  #   type = "indirect";
  #   id = "nixpkgs";
  # };

  # Non-flake inputs. These provide a variable of type path.
  # inputs.grcov = {
  #   type = "github";
  #   owner = "mozilla";
  #   repo = "grcov";
  #   flake = false;
  # };

  # Transitive inputs can be overridden from a flake.nix file. For example, the following overrides the nixpkgs input of the nixops input:
  # inputs.nixops.inputs.nixpkgs = {
  #   type = "github";
  #   owner = "NixOS";
  #   repo = "nixpkgs";
  # };

  # It is also possible to "inherit" an input from another input. This is useful to minimize
  # flake dependencies. For example, the following sets the nixpkgs input of the top-level flake
  # to be equal to the nixpkgs input of the nixops input of the top-level flake:
  # inputs.nixpkgs.url = "nixpkgs";
  # inputs.nixpkgs.follows = "nixops/nixpkgs";

  # The value of the follows attribute is a sequence of input names denoting the path
  # of inputs to be followed from the root flake. Overrides and follows can be combined, e.g.
  # inputs.nixops.url = "nixops";
  # inputs.dwarffs.url = "dwarffs";
  # inputs.dwarffs.inputs.nixpkgs.follows = "nixpkgs";

  # For more information about well-known outputs checked by `nix flake check`:
  # https://nixos.org/manual/nix/unstable/command-ref/new-cli/nix3-flake-check.html#evaluation-checks

  # These examples all use "x86_64-linux" as the system.
  # Please see the c-hello template for an example of how to handle multiple systems.

  # inputs.c-hello.url = "github:NixOS/templates?dir=c-hello";
  # inputs.rust-web-server.url = "github:NixOS/templates?dir=rust-web-server";
  # inputs.nix-bundle.url = "github:NixOS/bundlers";

  # Work-in-progress: refer to parent/sibling flakes in the same repository
  # inputs.c-hello.url = "path:../c-hello";

  outputs =
    {
      self,
      home-manager,
      nixpkgs,
      nixpkgs-unstable,
      nixpkgs-master,
      ...
    }@inputs:
    let
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
      overlays = import ./overlays/unstable.nix ({
        inherit
          pkgs
          pkgs-unstable
          pkgs-master
          lib
          ;
      });
      systems = {
        brock-thinkpad-nixos = {
          machine-config = ./NixOSConfig/machine-specific-configuration/thinkpad.nix;
          hardware-config = ./NixOSConfig/hardware-configuration/thinkpad.nix;
        };
        brock-pc-nixos = {
          machine-config = ./NixOSConfig/machine-specific-configuration/pc.nix;
          hardware-config = ./NixOSConfig/hardware-configuration/pc.nix;
        };
      };
      createSystem =
        name: value:

        lib.nixosSystem {
          inherit system;
          modules = [
            (
              { config, pkgs, ... }:
              {
                nixpkgs.overlays = overlays;
                nixpkgs.config.allowUnfree = unfreeAllowed;
              }
            )
            ./NixOSConfig/configuration.nix
            value.hardware-config
            value.machine-config
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = ".bak";
              home-manager.users.brock = import ./homeConfig/home.nix;
            }
          ];
        };
    in
    {
      nixosConfigurations = (lib.attrsets.mapAttrs createSystem systems);
      homeConfigurations.brock = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          (import ./homeConfig/home.nix)
        ];
      };

      # # Utilized by `nix flake check`
      # checks.x86_64-linux.test = c-hello.checks.x86_64-linux.test;

      # # Utilized by `nix build .`
      # defaultPackage.x86_64-linux = c-hello.defaultPackage.x86_64-linux;

      # # Utilized by `nix build`
      # packages.x86_64-linux.hello = c-hello.packages.x86_64-linux.hello;

      # # Utilized by `nix run .#<name>`
      # apps.x86_64-linux.hello = {
      #   type = "app";
      #   program = c-hello.packages.x86_64-linux.hello;
      # };

      # # Utilized by `nix bundle -- .#<name>` (should be a .drv input, not program path?)
      # bundlers.x86_64-linux.example = nix-bundle.bundlers.x86_64-linux.toArx;

      # # Utilized by `nix bundle -- .#<name>`
      # defaultBundler.x86_64-linux = self.bundlers.x86_64-linux.example;

      # # Utilized by `nix run . -- <args?>`
      # defaultApp.x86_64-linux = self.apps.x86_64-linux.hello;

      # # Utilized for nixpkgs packages, also utilized by `nix build .#<name>`
      # legacyPackages.x86_64-linux.hello = c-hello.defaultPackage.x86_64-linux;

      # # Default overlay, for use in dependent flakes
      # overlay = final: prev: { };

      # # # Same idea as overlay but a list or attrset of them.
      # overlays = { exampleOverlay = self.overlay; };

      # # Default module, for use in dependent flakes. Deprecated, use nixosModules.default instead.
      # nixosModule = { config, ... }: { options = {}; config = {}; };

      # # Same idea as nixosModule but a list or attrset of them.
      # nixosModules = { exampleModule = self.nixosModule; };

      devShells.x86_64-linux = {
        default = pkgs.mkShell {
          name = "devShell";
          packages = with pkgs; [
            man-pages
            man-pages-posix
            stdmanpages
            wev
            nixfmt-tree
          ];
        };
      };

      # # Utilized by Hydra build jobs
      # hydraJobs.example.x86_64-linux = self.defaultPackage.x86_64-linux;

      # # Utilized by `nix flake init -t <flake>`
      # defaultTemplate = {
      #   path = c-hello;
      #   description = "template description";
      # };

      # # Utilized by `nix flake init -t <flake>#<name>`
      # templates.example = self.defaultTemplate;
    };
}
