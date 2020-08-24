let
  pkgs = import /home/remy/nixpkgs {};
  helloworldFun = { stdenv, esptool }:
    stdenv.mkDerivation {
      name = "helloworld-1.0";
      src = ./.;
      allowSubstitutes = false;
      nativeBuildInputs = [ esptool ];
      installPhase = ''
        esptool.py --chip esp32 elf2image --flash_mode="dio" --flash_freq "40m" --flash_size "4MB" -o main.bin main.elf
        mkdir $out
        cp -v main.{elf,elf.map,bin} $out/
      '';
    };
  helloworld = pkgs.pkgsCross.esp32.callPackage helloworldFun {};
in {
  inherit helloworld;
}
