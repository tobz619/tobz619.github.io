{ shell-dir, pkgs ? import <nixpkgs> {} }:


let
  haskellPacks = pkgs.haskell.packages.${compiler};
  compiler = "ghc910";

in

haskellPacks.shellFor { 
    packages = hpkgs: [
      # hpkgs.distribution-nixpkgs
      (hpkgs.callPackage ./mysite.nix {})
    ];
    withHoogle = false;
    shellHook = ''
      export LOCALE_ARCHIVE="${pkgs.glibcLocales}/lib/locale/locale-archive";
      export LANG=en_US.UTF.8
      ${pkgs.cabal2nix}/bin/cabal2nix ./. > mysite.nix
    '';
    nativeBuildInputs = (with haskellPacks; [
      haskell-language-server
      hakyll
      cabal-install
      cabal2nix
      stack
      ormolu
    ]) ++ (with pkgs; [
      pkg-config
      pandoc
      texliveSmall
      firefox
    ]);
    doCheck = false;
}
