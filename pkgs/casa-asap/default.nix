{ fetchsvn,  cmake, stdenv,
  gcc, gfortran-debug, boost,
  casa, casacore, cfitsio,
  liblapackWithAtlasShared,
  python,  numpy, xorg, pgplot, rpfits, wcslib,
  # Perl script is used for SO Version string
  perl
 }:

 stdenv.mkDerivation rec {
    name = "casa-asap" ;
    revno= "3110";

    buildInputs = [ cmake gfortran-debug boost
    casa casacore cfitsio pgplot
    liblapackWithAtlasShared python numpy xorg.libXpm rpfits wcslib perl];

    src = fetchsvn {
    	url = http://svn.atnf.csiro.au/asap/trunk ;
	sha256 = "13zxi0dpwm7y8w68h55vdk0wyhyhz5krcs0vmx2i5fc3d1dds4ng";
	rev = "${revno}";
    };

    patches = [
        ./cmakefix.patch
	./casapath.patch	
    ];

    # Switch to proper fotran path
    cmakeFlags = [
     "-DCX11=1" 
     "-DCMAKE_Fortran_COMPILER=${gfortran-debug}/bin/gfortran"
     "-Dcasaroot=${casa}"
     "-DCASA_CODE_PATH=${casa}"
     "-DCASACORE_INCLUDE_DIR=${casacore}"
     "-DNUMPY_ROOT_DIR=${numpy}/lib/python2.7/site-packages/numpy/core"
     ];

     enableParallelBuilding = true;
}
