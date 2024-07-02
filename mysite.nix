{ mkDerivation, base, hakyll, zlib }:
mkDerivation {
  pname = "tobisite";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base hakyll ];
  license = "unknown";
  mainProgram = "site";
}
