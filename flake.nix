{
  description = "A very basic flake";

  inputs = { flake-utils.url = "github:numtide/flake-utils"; };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        inherit (nixpkgs) lib;

        pkgs = import nixpkgs { inherit system; };
      in { devShellModules = import ./modules.nix { inherit pkgs lib; }; });
}
