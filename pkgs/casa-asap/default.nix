{ fetchgit,  cmake, stdenv,
  gcc, gfortran, boost,
  casa, casacore, cfitsio,
  liblapackWithAtlasShared,
  python,  numpy, xorg, pgplot, rpfits, wcslib,
  # Perl script is used for SO Version string
  perl
 }:

 let
   srcs = import ../casasrc.nix {inherit fetchgit;};
 in
 stdenv.mkDerivation rec {
    name = "casa-asap" ;

    buildInputs = [ cmake gfortran boost
    casa casacore cfitsio pgplot
    liblapackWithAtlasShared python numpy xorg.libXpm rpfits wcslib perl];

    src  = srcs.src;

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

    sourceRoot = "${srcs.sourcePref}/asap";
}
