{
  description = "Flake for DAT320 R";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      rmark = pkgs.rPackages.buildRPackage {
        name = "rmarkdown";
        src = pkgs.fetchFromGitHub{
          owner = "rstudio";
          repo = "rmarkdown";
          rev = "b87ca50c8c4d5a5876333b598aed4eb84de925a3";
          sha256 = "12mhmmibizbxgmsns80c8h97rr7rclv9hz98zpgsl26hw3s4l0vm";
        };
   propagatedBuildInputs = with pkgs.rPackages; [caret mlbench dplyr ggplot2 knitr devtools shiny reticulate];
      };
    in {
      devShells.default = pkgs.mkShell {
        nativeBuildInputs = [ pkgs.bashInteractive ];
        buildInputs = with pkgs; [ R rmark pandoc ];
          shellHook = ''
            export PS1="\n\[\033[1;32m\][r_DAT320:\w]\$\[\033[0m\]"
            rstudio
          '';
      };
    });
}
