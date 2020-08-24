let
  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/taktoa/nixpkgs/archive/859e66dd48a40efa2a5645e611d73301833baeb2.tar.gz";
    sha256 = "1dxc6cvcjdh9p9dkfywswi3hqdxka8a5zqfq7klcs0ic1hq8nsj5";
  };
  pkgs = import nixpkgs {};
  helloworldFun = { stdenv, esptool }:
    stdenv.mkDerivation {
      name = "helloworld-1.0";
      src = ./.;
      allowSubstitutes = false;
      nativeBuildInputs = [ esptool ];
      installPhase = ''
        esptool.py --chip esp32 elf2image \
            --flash_mode="dio" \
            --flash_freq "40m" \
            --flash_size "4MB" \
            -o main.bin main.elf
        mkdir "$out"
        cp -v main.{elf,elf.map,bin} "$out/"
      '';
    };
  helloworld = pkgs.pkgsCross.esp32.callPackage helloworldFun {};
in {
  inherit pkgs helloworld;
}
