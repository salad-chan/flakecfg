{
  description = "flakecfg";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf.url = "github:notashelf/nvf";
  };

  outputs = { self, nixpkgs, nvf, ... }@inputs: {
    # use "nixos", or your hostname as the name of the configuration
    # it's a better practice than "default" shown in the video
    nixosConfigurations.system = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
	    nvf.nixosModules.default
        ./nixos/configuration.nix
        # inputs.home-manager.nixosModules.default
      ];
    };
  };
}
