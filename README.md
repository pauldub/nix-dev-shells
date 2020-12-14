# nix-dev-shells

A flake provides language specific [devshell](https://github.com/numtide/devshell) modules.

## Available devshell modules

- ruby 

Ruby, bundler and dependencies to build common native extensions.

- nix 

Support installing rnix-lsp language server and nixfmt linter.

- go 

## Usage

Add a `flake.nix` to your project with the following content:

```nix
{
  description = "My ruby project";

  inputs = {
    dev-shells.url = "github:pauldub/nix-dev-shells";
    devshell.url = "github:numtide/devshells";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, flake-utils, dev-shells, devshell, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ devshell.overlay ];
        };
      in { 
        devShell = pkgs.mkDevShell {
          imports = dev-shells.devshellModules."${system}";

          linter.enable = true;
          languageServer.enable = true;

          ruby.enable = true;
        }; 
      });
}
```

And run `devshell enter` or use the flake direnv integration described at: https://nixos.wiki/wiki/Flakes#Direnv_integration

This is the basic `.envrc` that I use:

```shell
use flake

layout ruby
```

