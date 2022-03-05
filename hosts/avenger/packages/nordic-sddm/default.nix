{ stdenv, fetchFromGitHub }:
{
 nordic-sddm = stdenv.mkDerivation rec {
    pname = "nordic-sddm";
    version = "2.1.0";
    dontBuild = true;
    src = fetchFromGitHub {
        owner = "EliverLara";
	    repo = "Nordic";
	    rev = "v${version}";
	    sha256 = "1s7yvpijfckj5zm444fk6yrfzc5v2lwaakfywfs1skypz3kq1hvi";
    };

    installPhase = ''
	    mkdir -p $out/share/sddm/themes/Nord
    	cp -r $src/kde/sddm/* $out/share/sddm/themes/Nord
    '';
 };
}
