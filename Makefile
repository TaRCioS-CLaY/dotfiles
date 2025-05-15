switch:
	home-manager switch --flake .

activate:
	nix --extra-experimental-features 'nix-command flakes' build .#homeConfigurations."$(whoami)".activationPackage

update:
	nix flake update
