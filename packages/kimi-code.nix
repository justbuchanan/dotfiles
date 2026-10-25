{
  lib,
  stdenv,
  fetchurl,
  patchelf,
}:

stdenv.mkDerivation rec {
  pname = "kimi-code";
  version = "2.3.0";

  src = fetchurl {
    url = "https://code.kimi.com/kimi-code/binaries/${version}/kimi-code-linux-x64";
    sha256 = "cf323ca555ccb69c11147e0ef3f0e3a771f873a7d1aa329ae60271450b265e48";
  };

  dontUnpack = true;
  dontStrip = true;

  nativeBuildInputs = [ patchelf ];

  # node SEA binary: --set-rpath corrupts the embedded blob, but these are safe
  installPhase = ''
    install -Dm755 $src $out/bin/kimi
    patchelf $out/bin/kimi \
      --set-interpreter ${stdenv.cc.bintools.dynamicLinker} \
      --replace-needed libstdc++.so.6 ${stdenv.cc.cc.lib}/lib/libstdc++.so.6
  '';

  meta = with lib; {
    description = "Kimi Code CLI agent from Moonshot AI";
    homepage = "https://code.kimi.com";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "kimi";
  };
}
