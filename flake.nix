{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs;
  };

  outputs =
    { nixpkgs, self }:

    let
      systems = [ "x86_64-linux" "aarch64-linux" "i686-linux" "x86_64-darwin" ];
    in

      {
        packages = nixpkgs.lib.genAttrs systems (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in {

            shmem-ipc = pkgs.callPackage ./nix/shmem-ipc.nix {};

            default = self.packages.${system}.shmem-ipc;
          });
      };
}
