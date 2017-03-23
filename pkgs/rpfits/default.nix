{ fetchurl, stdenv, gfortran }:

stdenv.mkDerivation rec {
  name = "rpfits-2.24";

  buildInputs = [gfortran];

  src = fetchurl {
    url = "ftp://ftp.atnf.csiro.au/pub/software/rpfits/${name}.tar.gz" ;
    sha256 = "09absmdk6bfnxavxwi1b3v196c8g1v1rswq4vxy34gh9n6gpa9gy";
  };

  sourceRoot="rpfits/linux";
  buildFlags = ["CFLAGS=-fPIC" "FFLAGS=-fPIC" ];
  makeFlags=[ "PREFIX=$(out)" "CFLAGS=-fPIC" "FFLAGS=-fPIC" ];

  meta = {
    homepage = http://www.atnf.csiro.au/computing/software/rpfits.html;

    description = "Data-recording format used since the mid-1980s within the Australia Telescope National Facility (ATNF)";
  };
}
