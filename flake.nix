{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    # bertcpp = "github.com:skeskinen/bert.cpp?submodules=1";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils, ... }:
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
          # (pkgs.fetchpatch {
          #   url = "http://localhost:8000/build.patch";
          #   hash =
          #     "sha256-OafnMTFhEDv8XF3wi+qix/3Zh40nDEaJP9j07U+HflI=";
          # })
          ./build.patch
        ];
        buildInputs = with pkgs ; [ ];
        nativeBuildInputs = with pkgs; [
          cmake
          breakpointHook
        ];
        cmakeFlags = [
          # "-DCMAKE_C_FLAGS=-Wno-format-security,-Wno-format"
          "-DBUILD_SHARED_LIBS=ON"
        ];
        hardeningDisable = [ "all" ];
        postInstall = ''
          # echo "postInstall >> || files here: "
          # ls
          # exit 1
        '';
      in
      {
        # inherit system buildInputs;
        packages.default = pkgs.stdenv.mkDerivation {
          inherit name src patches buildInputs nativeBuildInputs cmakeFlags
            hardeningDisable postInstall;
        };
      }
    );
}
