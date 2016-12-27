{ system ? builtins.currentSystem , crossSystem ? null, config ? null}:
let

  pkgs = (import <nixpkgs> ) { inherit system crossSystem config; };
  
  callPackage = pkgs.lib.callPackageWith (pkgs  // self);

  self = rec {

  ipython010 = with pkgs.lib;  pkgs.pythonPackages.buildPythonPackage rec {

    version = "0.10.2";
    name = "ipython-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/i/ipython/${name}.tar.gz";
      sha256 = "0iwcvzimmqczldpn62ivnmnxd03vc3jpldiyrjgbmrlj7mlzxmcy";
    };

    prePatch = pkgs.stdenv.lib.optionalString pkgs.stdenv.isDarwin ''
      substituteInPlace setup.py --replace "'gnureadline'" " "
    '';

    buildInputs = with self; with pkgs.pythonPackages; [nose] ++ optionals isPy27 [mock];

    propagatedBuildInputs = with self; with pkgs.pythonPackages;
      [twisted decorator pickleshare simplegeneric traitlets readline requests2 pexpect sqlite3]
      ++ pkgs.stdenv.lib.optionals pkgs.stdenv.isDarwin [appnope gnureadline];

  };

  casacore = callPackage pkgs/casacore {
      inherit (pkgs.pythonPackages) numpy;
      stdenv = pkgs.overrideCC pkgs.stdenv pkgs.gcc_debug;
   };
  casacore-data = callPackage pkgs/casacore-data { };

  casa = callPackage pkgs/casa {
        stdenv = pkgs.overrideCC pkgs.stdenv pkgs.gcc_debug;
  }; 

  # This does not work out-of-box on a system-wide nix install (i.e., nixbld user)
  #  casa = pkgs.lib.overrideDerivation (callPackage pkgs/casa { })
  #             (attrs: rec {       src= pkgs.fetchgitLocal "/home/bnikolic/oss/github-casa/"; });

  casa-data = callPackage pkgs/casa-data { };
  casa-asap = callPackage pkgs/casa-asap { inherit (pkgs.pythonPackages) numpy ;};
  casa-gcwrap = callPackage pkgs/casa-gcwrap {
      inherit (pkgs.pythonPackages) numpy matplotlib scipy dateutil six cycler pyparsing traitlets ipython_genutils decorator simplegeneric jupyter_core nose pygments pexpect backports_shutil_get_terminal_size pathlib2 pickleshare pathpy prompt_toolkit wcwidth ;
      ipython010=ipython010;
      readlinepython=pkgs.pythonPackages.readline;
      dbuspython=pkgs.pythonPackages.dbus-python;
      stdenv = pkgs.overrideCC pkgs.stdenv pkgs.gcc_debug;
   };  
  pgplot = callPackage pkgs/pgplot { };
  libsakura = callPackage pkgs/libsakura { };
  rpfits  = callPackage pkgs/rpfits { };
  wcslib = callPackage pkgs/wcslib { };
  breakpad = callPackage pkgs/breakpad {};

  liblapackWithAtlasShared = callPackage <nixpkgs/pkgs/development/libraries/science/math/liblapack> {shared=true;};  
# For easy access to consistent parent packages    
    inherit pkgs;
  };
in
    self
