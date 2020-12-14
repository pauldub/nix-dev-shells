{ config, lib, pkgs, ... }:

with lib;

let cfg = config.nix;
in {
  options.nix = {
    enable = mkEnableOption "Enable nix support";

    linter = mkOption {
      type = types.package;
      default = pkgs.nixfmt;
    };

    languageServer = mkOption {
      type = types.package;
      default = pkgs.rnix-lsp;
    };
  };

  config = mkIf cfg.enable {
    packages = lib.flatten [
      (mkIf config.linter.enable cfg.linter)
      (mkIf config.languageServer.enable cfg.languageServer)
    ];
  };
}
