{ fetchgit,  cmake, stdenv,
  gcc, gfortran, boost,
  casa, casacore, cfitsio,
  liblapackWithAtlasShared,
  python,  numpy, xorg, pgplot, rpfits, wcslib,
  # Perl script is used for SO Version string
  perl
 }:

 stdenv.mkDerivation rec {
    name = "casa-asap" ;

    buildInputs = [ cmake gfortran boost
    casa casacore cfitsio pgplot
    liblapackWithAtlasShared python numpy xorg.libXpm rpfits wcslib perl];

    gitrev="b20ad3818aebb1ad47a48e0d62413b75cce561fd";
    src = fetchgit {
    	url = https://open-bitbucket.nrao.edu/scm/casa/casa.git ;
	rev = "${gitrev}" ;
	sha256 = "1bmc4bmlmb7835nc5hg6zckkp6ncw1d4s8pbv5nlviin68ih5vgk";
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

     sourceRoot = "casa-b20ad38/asap";
}
