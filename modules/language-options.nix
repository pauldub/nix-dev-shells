{ lib }:

with lib;

{
  options = {
    linter = mkOption {
      description = "Which linter to use for this programming language";
      type = types.package;
    };

    languageServer = mkOption {
      description =
        "Which language server to use for this programming language";
      type = types.package;
    };
  };
}
