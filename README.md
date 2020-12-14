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
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, dev-shells, devshell, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ devshell.overlay ];
        };
      in { 
        devShell = pkgs.mkDevShell {
          imports = dev-shells.devShellModules."${system}";

          # Enable linter support, this will trigger the installation of the `ruby.linter`.
          linter.enable = true;
          # Enable language server support, this will trigger the installation of the `ruby.languageServer`.
          languageServer.enable = true;

          # Enable ruby support
          ruby.enable = true;

          # Add dependencies specific to Ruby on Rails applications.
          ruby.rails.enable = true;
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

