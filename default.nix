{ lib
, stdenv
, apacheHttpd
, autoconf
, automake
, autoreconfHook
, curl
, fetchFromGitHub
, libtool
, pkg-config
, apr
, aprutil
, jansson
, cjose
, pcre
, ...
}:

stdenv.mkDerivation rec {

  pname = "mod_auth_openidc";
  version = "2.4.16.6";

  src = fetchFromGitHub {
    owner = "OpenIDC";
    repo = "mod_auth_openidc";
    rev = "v${version}";
    sha256 = "sha256-ZyNurPC0nHzoUpCceCUg58MTMZEmUgDRO5q+ucGnzo8=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    autoconf
    automake
  ];
  buildInputs = [
    apacheHttpd
    apr
    aprutil
    jansson
    cjose
    pcre
    curl
    libtool
  ];

  configureFlags = [
    "--with-apxs2=${apacheHttpd.dev}/bin/apxs"
    "--exec-prefix=$out"
  ];

  installPhase = ''
    ls -la
    mkdir -p $out/bin
    mkdir -p $out/modules
    cp ./.libs/mod_auth_openidc.so $out/modules
  '';

  meta = with lib; {
    homepage = "https://github.com/OpenIDC/mod_auth_openidc";
    description = "Apache module implementing the OpenID Connect Relying Party functionality";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [
      {
        name = "Benjamin Hanzelmann";
        email = "benjamin@hanzelmann.de";
        github = "nabcos";
      }
    ];
  };

}
