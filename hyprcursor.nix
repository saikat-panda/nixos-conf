{ lib, stdenv, fetchFromGitHub, cargo }:

stdenv.mkDerivation rec {
  pname = "hyprcursor";
  version = "main"; # or a specific version tag

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprcursor";
    rev = "main";  # Replace with a specific commit if desired
    sha256 = lib.fakeSha256;  # Replace with the actual hash after first build
  };

  nativeBuildInputs = [ cargo ];

  buildPhase = ''
    cargo build --release
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp target/release/hyprcursor $out/bin/
  '';

  meta = with lib; {
    description = "Hyprland Cursor Management Daemon";
    homepage = "https://github.com/hyprwm/hyprcursor";
    license = licenses.mit;
    maintainers = with maintainers; [ yourGitHubUsername ];
  };
}
