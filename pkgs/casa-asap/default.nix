{ fetchsvn,  cmake, stdenv,
  gcc, gfortran, boost,
  casa, casacore, cfitsio,
  liblapackWithAtlasShared,
  python,  numpy, xorg, pgplot, rpfits, wcslib,
  # Perl script is used for SO Version string
  perl
 }:

 stdenv.mkDerivation rec {
    name = "casa-asap" ;
    revno= "3099";

    buildInputs = [ cmake gfortran boost
    casa casacore cfitsio pgplot
    liblapackWithAtlasShared python numpy xorg.libXpm rpfits wcslib perl];

    src = fetchsvn {
    	url = http://svn.atnf.csiro.au/asap/trunk ;
	sha256 = "0i8gl4kzvadi5fmz3rar447l3y3yfa0h0rxiy91sdrk6ayca07k6";
	rev = "${revno}";
    };

    patches = [
        ./cmakefix.patch
	./casapath.patch	
    ];

    # Switch to proper fotran path
    cmakeFlags = [
     "-DCX11=1" 
     "-DCMAKE_Fortran_COMPILER=${gfortran}/bin/gfortran"
     "-Dcasaroot=${casa}"
     "-DCASA_CODE_PATH=${casa}"
     "-DCASACORE_INCLUDE_DIR=${casacore}"
     "-DNUMPY_ROOT_DIR=${numpy}/lib/python2.7/site-packages/numpy/core"
     ];

     enableParallelBuilding = true;
}
