{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config, systemd }:

stdenv.mkDerivation rec {
  pname = "hypridle";
  version = "main";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hypridle";
    rev = "main";
    sha256 = lib.fakeSha256;
  };

  nativeBuildInputs = [ meson ninja pkg-config ];

  buildInputs = [ systemd ];

  installPhase = ''
    mkdir -p $out/bin
    cp build/hypridle $out/bin/
  '';

  meta = with lib; {
    description = "Hyprland's idle daemon";
    homepage = "https://github.com/hyprwm/hypridle";
    license = licenses.mit;
    maintainers = with maintainers; [ your-github-username ];
  };
}
