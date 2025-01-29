# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

# let
#   hypridle = pkgs.callPackage ./modules/hypridle/default.nix {};
# in {
#   environment.systemPackages = with pkgs; [ hypridle ];

#   # Enable Hypridle service
#   systemd.services.hypridle = {
#     description = "Hyprland Idle Daemon";
#     after = [ "graphical.target" ];
#     wantedBy = [ "graphical.target" ];
#     serviceConfig = {
#       ExecStart = "${hypridle}/bin/hypridle";
#       Restart = "always";
#     };
#   };
# }

{
  boot.kernelPackages = pkgs.linuxPackages_6_6;

  nix = {
    package = pkgs.nixVersions.latest;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  #Fonts avaliable systemwide
  fonts.packages = 
  [
    pkgs.nerd-fonts.jetbrains-mono
  ]; 
 
  # Setting up SDDM to act as login manager
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "tokyo-night-sddm";
  };
    
  services.flatpak.enable = true;				#enables flatpak store
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];	#installing desktop integration portals
  xdg.portal.config.common.default = "gtk";
  
  programs.hyprland.enable = true;				#enabling hyperland window manager

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  # boot.loader = {
  #   grub = {
  #     enable = true;
  #     device = "/dev/nvme0n1p5/";
  #     efiSupport = true;
  #   };
  #   efi = {
  #     canTouchEfiVariables = true;
  #     efiSysMountPoint = "/boot";
  #   };
  # };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #Enable NTFS support at boot
  boot.supportedFilesystems = ["ntfs"];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n = {
    defaultLocale ="en_IN";
  };

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sagitarius = {
    isNormalUser = true;
    description = "sagitarius";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.sessionVariables.NIXOS_OZONE_WL = "1";		#To use VS Code under Wayland, set the environment variable
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    foot
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-media-tags-plugin
    xfce.thunar-volman
    #ntfs
    wget
    htop
    yazi
    inputs.swww.packages.${pkgs.system}.swww		#Animated wallpaper solution
    waybar
    usbutils
    rofi-wayland
    gcc
    clang
    cmake
    libxkbcommon
    libxkbcommon.dev
    neofetch
    #inputs.zen-browser.packages."${system}".default	#Zen browser
    jdk
    #flameshot						#Has problems on wayland
    grim						#Grabs images from a Wayland compositor
    slurp						#Saves images to local storage
    nwg-look
    feh
    ffmpeg
    python3
    python311Packages.pip
    ollama
    git
    curl
    micro
    vlc
    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
      ];
    })
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        bbenoist.nix # syntax highlight for .nix files in vscode
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "search-crates-io";
          publisher = "belfz";
          version = "1.2.1";
          sha256 = "sha256-K2H4OHH6vgQvhhcOFdP3RD0fPghAxxbgurv+N82pFNs=";
        }
#        {
#          name = "python";
#          publisher = "ms.python";
#          version = "2024.22.2";
#          sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
#        }
      ];
    })
	pciutils
    file
    gnumake
    cudatoolkit
    cargo
    swayimg
    hyprlock
    (pkgs.libsForQt5.callPackage ./themes-SDDM/tokyo-night-sddm/default.nix { })
  ];

  services.xserver.videoDrivers = [ "nvidia" ];

  systemd.services.nvidia-control-devices = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.ExecStart = "${pkgs.linuxPackages.nvidia_x11.bin}/bin/nvidia-smi";
  };

  # systemd.services.hypridle = {
  # 	description = "Hyprland Idle Daemon";
  #   after = [ "graphical.target" ];
  #   wantedBy = [ "graphical.target" ];
  #   serviceConfig = {
  #     ExecStart = "${hypridle}/bin/hypridle";
  #     Restart = "always";
  #   };
  # };
  
  #Default Applications
  xdg.mime.defaultApplications = {
    "inode/directory" = [ "thunar.desktop" ]; # Replace `thunar.desktop` with your file manager's .desktop file
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
