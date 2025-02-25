{ pkgs ? import <nixpkgs> {}, compiler ? "ghc96"}:


let
  haskellPacks = pkgs.haskell.packages.${compiler};

in

haskellPacks.shellFor { 
    packages = hpkgs: [
      hpkgs.distribution-nixpkgs
      (hpkgs.callPackage ./mysite.nix {})
    ];
    withHoogle = true;
    shellHook = ''
      export LOCALE_ARCHIVE="${pkgs.glibcLocales}/lib/locale/locale-archive";
      export LANG=en_US.UTF.8
    '';
    nativeBuildInputs = (with haskellPacks; [
      haskell-language-server
      cabal-install
      cabal2nix
      stack
      ormolu
    ]) ++ (with pkgs; [
      pkg-config
    ]);
}
