{
  description = "My development environment";

  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
      java-nixpkgs.url = "github:nixos/nixpkgs/12a55407652e04dcf2309436eb06fef0d3713ef3";
    };

  outputs = { self, nixpkgs, java-nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      java-pkgs = java-nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system} =
        let
          common-tools = with pkgs; [ 
            git
            curl
            direnv
            lolcat
          ];
        in {
          ifpr = pkgs.mkShell {
            nativeBuildInputs = common-tools ++ (with pkgs; [
              java-pkgs.jdk24
              gnumake
            ]);

            shellHook = ''
              echo "In IFPR development environment" | lolcat
            '';
          };

          go = pkgs.mkShell {
            nativeBuildInputs = common-tools ++ (with pkgs; [
              go
            ]);

            hardeningDisable = [ "fortify" ];

            shellHook = ''
              echo "In Go development environment" | lolcat
            '';
          };
        };
    };
}
