{ pkgs, lib, ... }:

[
  ./modules/linter.nix
  ./modules/ruby.nix
  {
    config = {
      _module.args = {
      };
    };
  }
]
