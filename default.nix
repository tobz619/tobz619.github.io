{pkgs ? import <nixpkgs> {}}:

pkgs.haskellPackages.callPackage ./mysite.nix {}
