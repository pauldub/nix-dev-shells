{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.ruby;
in {
  options.ruby = mkOption {
    type = types.submodule {
      options = {
        enable = mkEnableOption "Enable ruby support";

        nativeExtensions = mkEnableOption "Add support for building native extensions";

        linter = mkOption {
          type = types.package;
          default = pkgs.rubyPackages.rubocop;
        };

        package = mkOption {
          type = types.package;
          default = pkgs.ruby;
        };

        bundler = mkOption {
          type = types.package;
          default = pkgs.bundler;
        };

        rails = mkOption {
          type = types.submodule {
            options = {
              enable = mkEnableOption "Enable Ruby on Rails support";

              nodejs = mkOption {
                type = types.package;
                default = pkgs.nodejs;
              };
            };
          };
        };
      };
    };
  };

  config = 
    let
      enableNativeExtensions = cfg.nativeExtensions || cfg.rails.enable;

      nativeExtensionsPackages = with pkgs; if enableNativeExtensions then [
        gcc
        gnumake
        pkgconfig
      ] else [];

      railsPackages = with pkgs; if cfg.rails.enable then [
          cfg.rails.nodejs

          # nokogiri 
          libxml2.dev
          libxslt.dev
          zlib.dev

          # ffi
          libffi.dev

          # postgresql
          postgresql_11.lib
      ] else [];
    in
      mkIf config.ruby.enable {
        packages = [
          (cfg.package.override {
            bundler = cfg.bundler;
          })
          (mkIf config.linter.enable cfg.linter)
        ] ++ railsPackages ++ nativeExtensionsPackages;

        bash.extra = mkIf enableNativeExtensions ''
            export PKG_CONFIG_PATH="$DEVSHELL_DIR/lib/pkgconfig"
        '';
      };
}
