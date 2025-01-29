{
  description = "NixOS configuration with flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    swww.url = "github:LGFae/swww";				#Animated wallpaper solution
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    #hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    #zen-browser.url = "github:MarceColl/zen-browser-flake";	#Zen browser flake
  };

  outputs = inputs@{ self, nixpkgs, swww, home-manager, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ 
        ./configuration.nix 
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.sagitarius = import ./home.nix;
          
#            programs.home-manager.enable = true;
#            home.packages = with pkgs; [
#              thunderbird
#            ];
        }
        {
          nix.settings.experimental-features = [
            "nix-command"
            "flakes"
          ];
        }
      ];
      specialArgs = { inputs = { inherit swww ; }; }; 
    };
  };
}

