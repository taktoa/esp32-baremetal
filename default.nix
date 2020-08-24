let
  #nixpkgsRev = "e73a0fab9d45827578153d16a01291c1f5d6d85e";
  nixpkgsRev = "b946610275674229145ed02174c519263483b5f3";
  #nixpkgsSha256 = "1z0bd8gsp1xcl5ghy3a2q6i0996rwpwflnki7zckzazbnkpa0q0v";
  nixpkgsSha256 = "00a6q041h98hbjmlvm0bshn6di4jr38jgzb0cabv5kdwq3ssj900";
  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/taktoa/nixpkgs/archive/${nixpkgsRev}.tar.gz";
    sha256 = nixpkgsSha256;
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
