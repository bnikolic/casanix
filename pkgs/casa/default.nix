{ fetchgit,  fetchsvn, cmake, stdenv, makeWrapper,
  gcc, gfortran, fftw, fftwSinglePrec,
  liblapackWithAtlas, cfitsio, flex, bison,
  wcslib, casacore, boost, xorg, qwt,
  pgplot, libsakura, rpfits,
  swig, blas, gsl, jre,
  dbus, dbus_cplusplus, dbus_tools, xercesc, sqlite, readline, ncurses, python , dbus_libs,
  libxslt,
  # Use pkgconfig to properly find dbus
  pkgconfig,
  # For potential fetch from SVN
  subversion, subversionClient,
  # Perl is used to create the SO version string
  perl,
  # Use breakpad, gtest package, not special download
  breakpad,   gtest, curl,
  # E.g. for colormaps
  casa-data
 }:

let
   srcs = import ../casasrc.nix {inherit fetchgit;};
 in
# TODO: google test at the moment has to be in tree. Factor out as separate package and make proper dependnecy
stdenv.mkDerivation rec {
    name = "casa";

    # Fakerevno: This is not in the SVN
    revno = "99";
    gitrev="b20ad3818aebb1ad47a48e0d62413b75cce561fd";

        buildInputs = [ cmake cfitsio gfortran flex bison liblapackWithAtlas wcslib casacore boost xorg.libXpm qwt
          pgplot libsakura rpfits
	  swig fftw fftwSinglePrec
	  blas gsl jre
  	  dbus dbus_cplusplus dbus_tools xercesc sqlite readline ncurses python dbus_libs
	  pkgconfig libxslt subversion subversionClient perl
	  breakpad gtest curl casa-data makeWrapper];

    src  = srcs.src;

    # Uses pkgconfig to dbus
    patches = [
        ./buildfix.patch
	./glibc225.patch
	./googletest.patch
    ];

    preConfigure = ''
       #Insert the feature no

       # This does not work because FEATURE is expected to be a numeric value
       #  substituteInPlace CMakeLists.txt --replace "CASA_VERSION_FEATURE 0 CACHE STRING" "CASA_VERSION_FEATURE \\\"git-${gitrev}\\\" CACHE STRING"

       substituteInPlace CMakeLists.txt --replace "CASA_VERSION_FEATURE 0 CACHE STRING" "CASA_VERSION_FEATURE ${revno} CACHE STRING"

        export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:${dbus}/lib/pkgconfig"
    '';

    # Switch to proper fotran path
    cmakeFlags = [
     "-DCMAKE_Fortran_COMPILER=${gfortran}/bin/gfortran"
     "-DGoogleTest_ReleaseRoot=${gtest}"
     "-DGoogleTest_LibraryDir=${gtest}/lib"
     "-DUseCrashReporter=0"
     ];

     hardeningDisable = [ "format" ];

     sourceRoot = "${srcs.sourcePref}/code";

     enableParallelBuilding = true;

     # ASAP requires the CASA CMake file to build
     postInstall = ''
     # NIX stdenv moves into the build subdir of sourcRoot
     cp -vr   ../install $out
     for a in asdm2MS asdmSummary bdflags2MS carmafiller casabrowser casa-config casafeather casafilecatalog casahistogram casalogger casapictureviewer casaplotms casaplotserver casaplotter casaprogresstimer casasplit casaviewer fixspwbackport imageconcat imcollapse imfit MS2asdm msuvbin qcasabrowser qwtplottertest t_minim wvrgcal
     do
	wrapProgram $out/bin/$a \
	   --prefix CASAPATH : "${casa-data}/share"
     done
     ''    ;
}
