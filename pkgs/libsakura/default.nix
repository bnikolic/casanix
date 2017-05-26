{ fetchurl,  stdenv, cmake, eigen, fftw , fftwSinglePrec, doxygen, gtest}:

# See also https://github.com/pkgw/conda-recipes/tree/master/recipes/libsakura

stdenv.mkDerivation rec {
  version = "3.0.0";
  name = "libsakura-${version}";

  buildInputs = [ cmake eigen fftw fftwSinglePrec doxygen] ;
  src = fetchurl {
    url = "https://svn.cv.nrao.edu/casa/devel/${name}.tar.gz";
    sha256 ="1i9784yi86w01z8p3iki753s6s9cfhjdy95qzxis3v1kysrdd1zk";
  };

  preConfigure = ''
        cp -r ${gtest.src} $NIX_BUILD_TOP/libsakura/gtest
	chmod u+w -R $NIX_BUILD_TOP/libsakura/gtest
        cmakeFlagsArray=( -DCMAKE_MODULE_PATH="$NIX_BUILD_TOP/libsakura/cmake-modules"  -DBUILD_DOC=OFF -DGTEST_INCLUDE_DIRS="$NIX_BUILD_TOP//libsakura/gtest/googletest/include/" );
    '';  

  cmakeFlagsArray =  [  ];

    patches = [
        ./stdnamespace.patch
    ];

  meta = {

    homepage = http://alma.mtk.nao.ac.jp/j/;

    license = stdenv.lib.licenses.lgpl3;
  };
}
