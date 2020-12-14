{ pkgs, lib, ... }:

[
  ./modules/tools.nix
  ./modules/ruby.nix
  ./modules/go.nix
  ./modules/nix.nix
]
