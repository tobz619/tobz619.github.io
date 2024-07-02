{ pkgs ? import <unstable> {}, compiler ? "ghc96"}:


pkgs.haskell.packages.${compiler}.shellFor { 
    packages = hpkgs: [
      hpkgs.distribution-nixpkgs
      (hpkgs.callPackage ./mysite.nix {})
    ];
    withHoogle = true;
    shellHook = ''
      export LOCALE_ARCHIVE="${pkgs.glibcLocales}/lib/locale/locale-archive";
      export LANG=en_US.UTF.8
    '';
    nativeBuildInputs = with pkgs; [
      haskell-language-server
      cabal-install
      cabal2nix
      haskell.packages."${compiler}".stack
      pkg-config
    ];
}
