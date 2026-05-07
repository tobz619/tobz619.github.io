{
  description = "Flake for Tobi's site";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?rev=f08e6b11a5ed43637a8ac444dd44118bc7d273b9";
  };

  outputs = { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    {
      devShells.x86_64-linux.default = import ./shell.nix { inherit pkgs ; shell-dir = "tobisite"; };

    };
}
