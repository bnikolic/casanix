{ stdenv, fetchgit }:

# Note this is a somewhat broken build (compare to stock nixpkgs) to accomodate CASA
stdenv.mkDerivation {
  name = "breakpad-2016-04-26";
  
  src = fetchgit {
    url = "https://chromium.googlesource.com/breakpad/breakpad";
    rev = "c2d969cb1050803961a53cfdbbcff5c69e579ebb";
    sha256 = "19kijxyx9nz9hf3zd1qfiijqsigcnlvblyrin1w848hsl21ps3qh";
  };

  breakpad_lss = fetchgit {
    url = "https://chromium.googlesource.com/linux-syscall-support";
    rev = "08056836f2b4a5747daff75435d10d649bed22f6";
    sha256 = "1ryshs2nyxwa0kn3rlbnd5b3fhna9vqm560yviddcfgdm2jyg0hz";
  };

  enableParallelBuilding = true;

  prePatch = ''
    cp -r $breakpad_lss src/third_party/lss
    chmod +w -R src/third_party/lss
  '';

   postInstall = ''
     # CASA requires the CC file which contains static methods. Bad Karma
     cp -vr   src/common/linux/http_upload.cc $out/include/breakpad/common/linux/
     substituteInPlace $out/include/breakpad/common/linux/http_upload.cc --replace "third_party/curl/curl.h" "curl/curl.h"
   '';

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
