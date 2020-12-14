{
  description = "A collection of devshell modules";

  inputs = { flake-utils.url = "github:numtide/flake-utils"; };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        inherit (nixpkgs) lib;

        pkgs = import nixpkgs { inherit system; };
      in { devshellModules = import ./modules.nix { inherit pkgs lib; }; });
}
