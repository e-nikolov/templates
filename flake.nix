{
  inputs = { };

  outputs = inputs@{ ... }: {
    templates = {
      devenv = {
        path = ./templates/devenv;
        description = "A direnv supported Nix flake with devenv integration.";
        welcomeText = ''
          # Run ./devenv-setup to complete the setup.
        '';
      };
    };
  };
}
