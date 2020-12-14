{ config, lib, pkgs, ... }:

with lib;

let cfg = config.go;
in {
  options.go = {
    enable = mkEnableOption "Enable Golang support";

    languageServer = mkOption {
      type = types.package;
      default = pkgs.gopls;
    };

    package = mkOption {
      type = types.package;
      default = pkgs.go;
    };
  };

  config = mkIf cfg.enable {
    packages = lib.flatten [
      cfg.package
      (mkIf config.languageServer.enable cfg.languageServer)
    ];
  };
}
