# Universal shell for PureScript repos
{ pkgs ? import (builtins.fetchGit {
  # https://github.com/NixOS/nixpkgs/releases/tag/21.11
  url = "https://github.com/nixos/nixpkgs/";
  ref = "refs/tags/21.11";
  rev = "a7ecde854aee5c4c7cd6177f54a99d2c1ff28a31";
  }) {}
}:
let
  easy-ps-src = builtins.fetchGit {
    url = "https://github.com/justinwoo/easy-purescript-nix.git";
    ref = "master";
    rev = "0ad5775c1e80cdd952527db2da969982e39ff592";
  };
  easy-ps = import easy-ps-src { inherit pkgs; };
in
pkgs.mkShell {
  nativeBuildInputs = [
    easy-ps.purs-0_15_0
    easy-ps.spago
    easy-ps.pulp-16_0_0-0
    easy-ps.psc-package
    easy-ps.purs-tidy
    pkgs.nodejs-16_x
    pkgs.nodePackages.bower
  ];
  LC_ALL = "C.UTF-8"; # https://github.com/purescript/spago/issues/507
  # https://github.com/purescript/spago#install-autocompletions-for-bash
  shellHook = ''
    source <(spago --bash-completion-script `which spago`)
  '';
}
