{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, flake-utils, poetry2nix, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        name = "bert.cpp";
        src = pkgs.fetchFromGitHub {
          owner = "skeskinen";
          repo = "bert.cpp";
          fetchSubmodules = true;
          rev = "2e76d7bff13657876b2afdc4e562ee51329b7dbb";
          hash = "sha256-9IZB3bg/taCJqLdUjEit3YzGyl9JTvDYM0nAi+WKnLg=";
        };
        patches = with pkgs ; [
          ./build.patch
          ./package.patch
        ];
        buildInputs = with pkgs ; [ ];
        nativeBuildInputs = with pkgs; [
          cmake
          breakpointHook
        ];
        cmakeFlags = [
          "-DBUILD_SHARED_LIBS=ON"
        ];
        hardeningDisable = [ "all" ];
        postInstall = ''
        '';
      in
      {
        packages.default = pkgs.stdenv.mkDerivation
          {
            inherit name src patches buildInputs nativeBuildInputs cmakeFlags
              hardeningDisable postInstall;
          };

        packages.scripts = poetry2nix.legacyPackages.${system}.mkPoetryApplication {
          projectDir = pkgs.applyPatches { inherit src patches; };
        }
        ;
      }
    );
}
