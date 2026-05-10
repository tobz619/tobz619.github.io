{ mkDerivation, base, clay, hakyll, lib, text }:
mkDerivation {
  pname = "tobisite";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base clay hakyll text ];
  license = "unknown";
  mainProgram = "site";
}
