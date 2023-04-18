{ pkgs, ... }:

{
  packages = with pkgs; [
    git
    nodejs-18_x
    # prisma-engines
    nodePackages.pnpm
    # nodePackages.prisma
    nodePackages.prettier
    nodePackages.typescript-language-server
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
  #   initialDatabases = [{name = "unik";}];
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
