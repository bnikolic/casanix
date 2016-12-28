{ fetchgit,  fetchsvn, cmake, stdenv, makeWrapper,
  gcc, gfortran-debug, fftw, fftwSinglePrec,
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

# TODO: google test at the moment has to be in tree. Factor out as separate package and make proper dependnecy
stdenv.mkDerivation rec {
    name = "casa";
    revno= "39193";
    gitrev="e438ab523d7adc71e63fd69c7df40eade7b0ec51";
    buildInputs = [ cmake cfitsio gfortran-debug flex bison liblapackWithAtlas wcslib casacore boost xorg.libXpm qwt
          pgplot libsakura rpfits
	  swig fftw fftwSinglePrec
	  blas gsl jre
  	  dbus dbus_cplusplus dbus_tools xercesc sqlite readline ncurses python dbus_libs
	  pkgconfig libxslt subversion subversionClient perl
	  breakpad gtest curl casa-data makeWrapper];

    # The SVN is the master version by NRAO. The SVN and GIT versions
    # are nearby but necessarily exactly the same revisions.
    src = fetchsvn {
    	url = https://svn.cv.nrao.edu/svn/casa/trunk;
	rev = "${revno}";
	sha256 = "1lb6dmi235s5kshvwmhp3yykfg8m4vwcw5f3bwip5qbpgskggcrs";
    };

    # src = fetchgit {
    # url = file:///home/bnikolic/oss/github-casa/ ;
    # rev = "${gitrev}" ;
    # sha256 = "0iarrdyrd3vmy2jdmsdq5z4j0k3v4hhvfflgkbwsh93kxgf6w2ij";
    # };

    # Uses pkgconfig to dbus
    patches = [
        ./buildfix.patch
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
     "-DCMAKE_Fortran_COMPILER=${gfortran-debug}/bin/gfortran"
     "-DGoogleTest_ReleaseRoot=${gtest}"
     "-DGoogleTest_LibraryDir=${gtest}/lib"
     ];

     hardeningDisable = [ "format" ];

     sourceRoot = "casa-r${revno}/code";
#     sourceRoot = "github-casa-e438ab5/code";     

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
