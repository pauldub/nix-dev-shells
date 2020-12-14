{
  description = "A very basic flake";

  inputs = {
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, devshell }: rec {
    shells = flake-utils.lib.eachDefaultSystem (system:
      let
        inherit (nixpkgs) lib;

        pkgs = import nixpkgs {
          inherit system;
          overlays = [ devshell.overlay ];
        };

        mkRubyShell = rubyPackage: bundlerPackage:
          (lib.makeOverridable pkgs.mkDevShell {
            packages = with pkgs; [
              (rubyPackage.override { bundler = bundlerPackage; })
              nodejs

              pkgconfig
              binutils
              gcc
              gnumake
              libxml2.dev
              libxslt.dev
              zlib.dev
              libffi.dev

              postgresql_11
            ];

            bash.extra = ''
              export PKG_CONFIG_PATH="$DEVSHELL_DIR/lib/pkgconfig"
            '';
          });
      in {
        mkShell = configuration: let
          shellModules = import ./modules.nix {
            inherit pkgs lib;
          };
        in (lib.makeOverridable pkgs.mkDevShell {
          imports = shellModules ++ [
            configuration
          ];
        });

        ruby = mkRubyShell pkgs.ruby pkgs.bundler; });
    lib = {

      devShell = system: lang: shells."${lang}"."${system}"; };
  };
}
