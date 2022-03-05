
{ lib, stdenv, fetchgit }:

let 
   commit = "92396b11459e7a4b5e8ff511e99d18d7a1589c96";
in

stdenv.mkDerivation {
	pname = "pridecat";
	version = commit;
	src = fetchgit {
	  url = "https://github.com/lunasorcery/pridecat.git";
	  rev = commit;
	  sha256 = "0gy6rsjz1qnf45262w7j5fbf5p232mzmwx9hhxbm3xi1pdnqn89z";
	};
	patches = [ ./fix_install.patch ];
}
