{ fetchurl, stdenv }:

stdenv.mkDerivation {
   name = "casacore-data";
   src = fetchurl {
      url = ftp://ftp.astron.nl/outgoing/Measures/WSRT_Measures_20160919-000001.ztar;
      sha256 = "1jh130w4d0156k3qy2g2g9w4m6xism84k26411981040xwm8cj53";
   };

   unpackCmd = "(mkdir casacore-data; cd casacore-data;  tar xzf $curSrc)" ;
   dontBuild = true;

   installPhase = "mkdir -p $out/share/casacore-data; cp -r *  $out/share/casacore-data";   


}
   
