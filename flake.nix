{
  description = "Pinentry Keyring";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      supportedSystems = [ "aarch64-linux" "x86_64-linux" ];
      allSystems = supportedSystems ++ [ "aarch64-darwin" "x86_64-darwin" ];
    in (flake-utils.lib.eachSystem supportedSystems (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        packages.pinentry-keyring = pkgs.callPackage ./. { };
        defaultPackage = packages.pinentry-keyring;
      })) // (flake-utils.lib.eachSystem allSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in {
          devShell = pkgs.mkShell {
            buildInputs = with pkgs; [ go gopls gotools go-tools ];
          };
        })) // {
          overlays.pinentry-keyring = final: prev: {
            pinentry-keyring = final.callPackage ./.. { };
          };
          overlay = self.overlays.pinentry-keyring;
        };
}
