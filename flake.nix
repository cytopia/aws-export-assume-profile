{
  description = "aws-export-assume-profile nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      version = "0.4";
      hash = "sha256-5vUoQpO6KrTsrgUveMifDu0HfMgWMoGeCroLcjRciyQ=";
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          runtimeDeps = [
            pkgs.awscli2
            pkgs.gnugrep
            pkgs.gawk
          ];
        in
        {
          "aws-export-assume-profile" = pkgs.stdenv.mkDerivation {
            pname = "aws-export-assume-profile";
            version = "0.4";

            src = pkgs.fetchurl ({
              url = "https://raw.githubusercontent.com/cytopia/aws-export-assume-profile/refs/tags/v${version}/aws-export-assume-profile";
              sha256 = hash;
            });

            nativeBuildInputs = [ ];
            buildInputs = runtimeDeps;
            dontUnpack = true;
            installPhase = ''
              mkdir -p $out/bin
              cp $src $out/bin/aws-export-assume-profile
              chmod +x $out/bin/aws-export-assume-profile
            '';

          };
          default = self.packages.${system}."aws-export-assume-profile";
        }
      );
    };
}
