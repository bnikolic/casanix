{ fetchurl, stdenv }:

stdenv.mkDerivation {
   name = "casacore-data";
   src = fetchurl {
      url = ftp://ftp.astron.nl/outgoing/Measures/WSRT_Measures_20170320-000004.ztar;
      sha256 = "114jc1lrwygam83641nhav2sdx9pnya7f3h8j5wfwwcifyxirb7r";
   };

   unpackCmd = "(mkdir casacore-data; cd casacore-data;  tar xzf $curSrc)" ;
   dontBuild = true;

   installPhase = "mkdir -p $out/share/casacore-data; cp -r *  $out/share/casacore-data";   


}
   
