{
  inputs = { };

  outputs = inputs@{ ... }: {
    templates = {
      devenv = {
        path = ./templates/devenv;
        description = "A direnv supported Nix flake with devenv integration.";
        welcomeText = ''
          # Run `direnv allow` and then `setup-devenv` to complete the setup.
        '';
      };
    };
  };
}
