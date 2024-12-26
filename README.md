# Nix derivation for [mod_auth_openidc](https://github.com/OpenIDC/mod_auth_openidc)

To load in a flake-based nixos configuration:

```nix
inputs.nixos.url = "...";
inputs.mod-auth-openidc.url = "github:nabcos/nixos-mod-auth-openidc";
outputs = inputs @ {self, nixos, mod-auth-openidc} : {
    nixosConfigurations.host = nixos.lib.nixosSystem {
        specialArgs = inputs;
        system = "x86_64-linux";
        modules = [
            ./hosts/test.nix
            (
                { ... }:
                {
                    nixpkgs.overlays = [ 
                        (final: prev: {
                            apacheHttpdPackages = prev.apacheHttpdPackages // {
                                mod_auth_openidc = (import inputs.mod-auth-openidc prev // {
                                    system = final.system;
                                });
                            };
                        )
                    ];
                }
            )
        ];
    };
};
```

Then set up httpd-service with extraModules:

```nix
services.httpd.extraModules = [
    { name = "auth_openidc"; path = "${pkgs.apacheHttpdPackages.mod_auth_openidc}/modules/mod_auth_openidc.so"; }
];
```
