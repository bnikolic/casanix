{ fetchsvn, stdenv }:

stdenv.mkDerivation rec {
   name = "casadata-data";
   revno= "10808";
   src = fetchsvn {
      url = https://svn.cv.nrao.edu/svn/casa-data/distro ;
      rev = "${revno}";      
      sha256 = "0hh29q84jg9k6ws4fwdqbbgy8j7pzp978ii8m475yv4wknr5pgb0";
   };

   dontBuild = true;

   installPhase = "mkdir -p $out/share/data;  cp -r *  $out/share/data";   


}
   
