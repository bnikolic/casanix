{fetchgit} :

let
    gitrev="5639f6e9b0cfa7dd3131fa101c6c1201cb19eb47";
in     
{
    src = fetchgit {
    	url = https://open-bitbucket.nrao.edu/scm/casa/casa.git ;
	rev = "${gitrev}" ;
	sha256 = "1j845i0axllk7c1fxkmb4dwqkc34xr8v5n8ajxqr5wa29zc5k48n";
    };

    sourcePref = "casa-5639f6e";
}	
