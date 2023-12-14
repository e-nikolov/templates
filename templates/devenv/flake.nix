{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
  };

  nixConfig = {
    extra-trusted-public-keys =
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = { self, nixpkgs, devenv, systems, ... }@inputs:
    let forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in {
      devShells = forEachSystem (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = devenv.lib.mkShell {
            inherit inputs pkgs;
            modules = [{
              # https://devenv.sh/reference/options/
              packages = [
                pkgs.hello
                pkgs.git
                # pkgs.poetry
                # pkgs.python312Packages.pip
                pkgs.just
                # pkgs.yarn
                # pkgs.bun
                # pkgs.nodePackages_latest.pnpm
              ];

              # languages.nix.enable = true;

              # languages.javascript.enable = true;
              # languages.javascript.corepack.enable = true;
              # languages.typescript.enable = true;
              # languages.python.enable = true;
              # languages.python.package = pkgs.python312;

              enterShell = ''
                hello
              '';

              scripts.setup-devenv.exec = ''
                #!/usr/bin/env bash

                if [[ ! -f ".git" ]]; then
                  git init .
                  echo "set up git repository"
                fi

                if [[ ! -f ".gitignore" ]]; then
                    touch .gitignore
                    echo "added .gitignore"
                fi

                if ! <.gitignore grep '.devenv'; then
                    touch .gitignore
                    echo ".devenv/" >> .gitignore
                    echo "added .devenv to .gitignore"
                    git add .gitignore
                fi

                if ! <.gitignore grep '.direnv'; then
                    echo ".direnv/" >> .gitignore
                    echo "added .direnv to .gitignore"
                    git add .gitignore
                fi

                git add .envrc
                git add flake.nix
                git add flake.lock
              '';
            }];
          };
        });
    };
}
