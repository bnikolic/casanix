{ fetchgit,  cmake, stdenv,
  gcc, gfortran, fftw, fftwSinglePrec,
  liblapackWithAtlas, cfitsio, flex, bison,
  wcslib, casacore-data,
  # For the Python wrapper
  python,  boost, numpy
 }:

stdenv.mkDerivation rec {
    name = "casacore";
    buildInputs = [ cmake cfitsio gfortran flex bison liblapackWithAtlas wcslib casacore-data python
    boost numpy ];

    gitrev="b20ad3818aebb1ad47a48e0d62413b75cce561fd";
    src = fetchgit {
    	url = https://open-bitbucket.nrao.edu/scm/casa/casa.git ;
	rev = "${gitrev}" ;
	sha256 = "1bmc4bmlmb7835nc5hg6zckkp6ncw1d4s8pbv5nlviin68ih5vgk";
    };

    cmakeFlags = [
     "-DCXX11=1"
     "-DDATA_DIR=${casacore-data}/share/casacore-data"
     "-DCMAKE_LIBRARY_PATH=${gfortran}/lib"
     "-DUseCasacoreNamespace=0"
     ];

     enableParallelBuilding = true;

    sourceRoot = "casa-b20ad38/casacore";
}
