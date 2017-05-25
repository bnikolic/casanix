{ fetchurl, stdenv, gfortran }:

stdenv.mkDerivation rec {
  name = "rpfits-2.24";

  buildInputs = [gfortran];

  src = fetchurl {
    url = "ftp://ftp.atnf.csiro.au/pub/software/rpfits/${name}.tar.gz" ;
    sha256 = "0p7bzsp1wmcs2plb151s0gps2q76g3wp0cqzjbsl7i9ndg6fn1dk";
  };

  sourceRoot="rpfits/linux";
  buildFlags = ["CFLAGS=-fPIC" "FFLAGS=-fPIC" ];
  makeFlags=[ "PREFIX=$(out)" "CFLAGS=-fPIC" "FFLAGS=-fPIC" ];

  meta = {
    homepage = http://www.atnf.csiro.au/computing/software/rpfits.html;

    description = "Data-recording format used since the mid-1980s within the Australia Telescope National Facility (ATNF)";
  };
}
