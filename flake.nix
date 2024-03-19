{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = {
    self,
    nixpkgs,
    devenv,
    systems,
    ...
  } @ inputs: let
    forEachSystem = nixpkgs.lib.genAttrs (import systems);
  in {
    packages = forEachSystem (system: {
      devenv-up = self.devShells.${system}.default.config.procfileScript;
    });

    devShells =
      forEachSystem
      (system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = devenv.lib.mkShell {
          inherit inputs pkgs;
          modules = [
            {
              packages = with pkgs; [
                git
                nodejs-18_x
                nodePackages.pnpm
                nodePackages.prettier
                nodePackages.typescript-language-server

                # prisma-engines
                # nodePackages.prisma
              ];

              languages.typescript.enable = true;

              pre-commit.hooks = {
                eslint.enable = true;
                prettier.enable = true;
                # editorconfig-checker.enable = true;
              };

              # services.postgres = {
              #   enable = true;
              #   listen_addresses = "127.0.0.1";
              #   port = 5432;
              #   initialScript = ''
              #     CREATE ROLE pguser LOGIN SUPERUSER PASSWORD 'password';
              #   '';
              #   initialDatabases = [{name = "dbname";}];
              # };

              # env.PRISMA_MIGRATION_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/migration-engine";
              # env.PRISMA_QUERY_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/query-engine";
              # env.PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines}/lib/libquery_engine.node";
              # env.PRISMA_INTROSPECTION_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/introspection-engine";
              # env.PRISMA_FMT_BINARY = "${pkgs.prisma-engines}/bin/prisma-fmt";

              # services.redis.enable = true;
              processes.server = {
                exec = "pnpm start:dev";
              };
            }
          ];
        };
      });
  };
}
