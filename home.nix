{ lib, config, pkgs, ... }: 

let 
  # Waybar configuration and styling files
  waybarConfig = builtins.readFile ./waybar/config.json;
  waybarStyle = builtins.readFile ./waybar/style.css;

#let
#  waybarConfig = pkgs.writeTextFile{
#    name = "waybar-config.json";
#    text = ''
#      {
#        
#        "layer": "bottom",
#        "position": "top",
#        "height": 24,
#        "spacing": 5,
#        "modules-left": ["sway/workspaces","sway/mode"],
#        "modules-center": ["sway/window"],
#        "modules-right": ["idle_inhibitor","cpu","memory","battery","pulseaudio","clock","tray"]
#      }'';
#  };
in   
{
  imports = [./modules/waybar.nix ];

  #Transfers file management responsibility from home-manager to user
  home.file."/etc/sddm.conf".enable = lib.mkForce false; 
  home.file."/home/sagitarius/.config/waybar/config".enable = lib.mkForce false;
  home.file."/home/sagitarius/.config/waybar/style.css".enable = lib.mkForce false;
  
  # Home Manager configuration for the user "sagitarius"
  home.username = "sagitarius";
  home.homeDirectory = "/home/sagitarius";
  programs.home-manager.enable = true;
  home.packages = with pkgs;
  [ 
    # waybar
    thunderbird
  ];
 
#   xdg.configFile."waybar/config".text = waybarConfig;
#   xdg.configFile."waybar/style.css".text = waybarStyle;

  programs.zsh.enable = true; # Example: Enable Zsh
  home.stateVersion = "23.11"; # Adjust to match your NixOS version
}
