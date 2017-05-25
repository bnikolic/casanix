{ fetchgit,  cmake, stdenv,
  gcc, gfortran, fftw, fftwSinglePrec,
  liblapackWithAtlas, cfitsio, flex, bison,
  wcslib, casacore-data,
  # For the Python wrapper
  python,  boost, numpy
 }:

 let
     srcs = import ../casasrc.nix {inherit fetchgit;};
  in
stdenv.mkDerivation rec {
    name = "casacore";
    buildInputs = [ cmake cfitsio gfortran flex bison liblapackWithAtlas wcslib casacore-data python
    boost numpy ];

    src = srcs.src;

    cmakeFlags = [
     "-DCXX11=1"
     "-DDATA_DIR=${casacore-data}/share/casacore-data"
     "-DCMAKE_LIBRARY_PATH=${gfortran}/lib"
     "-DUseCasacoreNamespace=1"
     ];

     enableParallelBuilding = true;

    sourceRoot = "${srcs.sourcePref}/casacore";
}
