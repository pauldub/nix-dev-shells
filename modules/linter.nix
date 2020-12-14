{ config, lib, pkgs, ... }:

{
  options.linter = {
    enable = lib.mkEnableOption "Enable linter integration";
  };
}
