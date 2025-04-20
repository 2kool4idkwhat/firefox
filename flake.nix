{
  description = "Custom Firefox version";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = { self, nixpkgs, ... }: let
    inherit (nixpkgs) lib;
  in {
    packages = lib.genAttrs ["x86_64-linux" "aarch64-linux"] (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = self.packages.${system}.firefox;
      firefox = (pkgs.wrapFirefox pkgs.firefox-unwrapped {
        extraPoliciesFiles = import ./policy.nix {inherit lib;}
          |> pkgs.writers.writeJSON "policy.json"
          |> lib.singleton;
      });

    });
  };
}
