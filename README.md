# nix-dev-shells

A flake that builds language specific devshell using https://github.com/numtide/devshell.

## Available shells

- ruby (latest) 

Ruby, bundler and dependencies to build common native extensions.

## Usage

Add a `flake.nix` to your project with the following content:

```nix
{
  description = "My ruby project";

  inputs = {
    dev-shells.url = "github:pauldub/nix-dev-shells";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, flake-utils, dev-shells, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let inherit (dev-shells.lib) devShell;
      in { devShell = (devShell system "ruby"); });
}
```

And run `devshell enter` or use the flake direnv integration described at: https://nixos.wiki/wiki/Flakes#Direnv_integration

This is the basic `.envrc` that I use:

```shell
use flake

layout ruby
```

## Overriding default attributes

The `devShell` args can be overriden with the default override mechanism. You can use all arguments defined by https://github.com/numtide/devshell `mkDevShell`.

```nix
{
  description = "My ruby project";

  inputs = {
    dev-shells.url = "github:pauldub/nix-dev-shells";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, flake-utils, dev-shells, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let inherit (dev-shells.lib) devShell;
      in { devShell = (devShell system "ruby").override { env.DATABASE_URL = "postgres:///my_ruby_project"; }; });
}
```
