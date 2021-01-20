{ config, lib, pkgs, ... }:

with lib;

let cfg = config.ruby;
in {
  options.ruby = {
    enable = mkEnableOption "Enable ruby support";

    nativeExtensions =
      mkEnableOption "Add support for building native extensions";

    linter = mkOption {
      type = types.package;
      default = pkgs.rubocop;
    };

    languageServer = mkOption {
      type = types.package;
      default = pkgs.solargraph;
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ruby;
    };

    bundler = mkOption {
      type = types.package;
      default = pkgs.bundler;
    };

    postgresql = mkOption {
      type = types.package;
      default = pkgs.postgresql_11;
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

  config = let
    enableNativeExtensions = cfg.nativeExtensions || cfg.rails.enable;

    nativeExtensionsPackages = with pkgs;
      optionals enableNativeExtensions [ gcc gnumake pkgconfig ];

    railsPackages = with pkgs;
      optionals cfg.rails.enable [
        cfg.rails.nodejs

        # nokogiri
        libxml2.dev
        libxslt.dev
        zlib.dev

        # ffi
        libffi.dev

        # postgresql
        cfg.postgresql
        cfg.postgresql.lib
      ];
  in mkIf cfg.enable {
    packages = lib.flatten [
      (cfg.package.override { bundler = cfg.bundler; })
      (mkIf config.linter.enable cfg.linter)
      (mkIf config.languageServer.enable cfg.languageServer)
    ] ++ nativeExtensionsPackages ++ railsPackages;

    bash.extra = mkIf enableNativeExtensions ''
      export PKG_CONFIG_PATH="$DEVSHELL_DIR/lib/pkgconfig"
    '';
  };
}
