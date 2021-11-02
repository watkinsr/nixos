with import <nixpkgs> {};

stdenv.mkDerivation {
    name = "default-env";

    buildInputs = [
	ripgrep
	gitui
    ];

shellHook = ''
    '';
}
