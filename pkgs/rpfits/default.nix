{ fetchurl, stdenv, gfortran }:

stdenv.mkDerivation rec {
  name = "rpfits-2.23";

  buildInputs = [gfortran];

  src = fetchurl {
    url = "ftp://ftp.atnf.csiro.au/pub/software/rpfits/${name}.tar.gz" ;
    sha256 = "1811y9iynzsb01p0589k5j0nww5imm3z829bs3l6w50n3faxkgkz";
  };

  sourceRoot="rpfits/linux";
  buildFlags = ["CFLAGS=-fPIC" "FFLAGS=-fPIC" ];
  makeFlags=[ "PREFIX=$(out)" "CFLAGS=-fPIC" "FFLAGS=-fPIC" ];

  meta = {
    homepage = http://www.atnf.csiro.au/computing/software/rpfits.html;

    description = "Data-recording format used since the mid-1980s within the Australia Telescope National Facility (ATNF)";
  };
}
