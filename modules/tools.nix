{ config, lib, pkgs, ... }:

{
  options = {
    linter = { enable = lib.mkEnableOption "Enable linter support"; };

    languageServer = {
      enable = lib.mkEnableOption "Enable language server support";
    };
  };
}
