{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  # enable sound with pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  ### home manager ###
  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      "KenJolno" = import ../home-manager/home.nix;
    };
  };

  ### Nvidia drive ###
  hardware.graphics = {
    enable = true;
  };  # OpenGL support

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  ### Hybrid Graphics ###
  hardware.nvidia.prime = {
    sync.enable = true;
    amdgpuBusId = "PCI:6:0:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  ### dae ###
  services.dae = {
    enable = true;
    configFile = "/etc/dae/Config.dae";
    assets = with pkgs; [
	#v2ray-geoip
	v2ray-domain-list-community
    ];
  };

  ### substituters ###
  #settings = {
  #  substituters = [
  #    "https://mirror.tuna.tsinghua.edu.cn/nix-channels/store"
  #    "https://cache.nixos.org/"
  #  ];
  #};

  environment.systemPackages = with pkgs; [
    nixd
    brave
    vim
    wget
    git
    neofetch
    curl
    tree
    unzip
    dae

    # hyprland
    waybar
    rofi-wayland
    mako
    libnotify # for mako
    kitty # terminal
    swww
    networkmanagerapplet

    # waybar attribute override
    #(waybar.overrideAttrs (oldAttr: {
     # mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    #}))
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };


  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  #services.desktopManager.plasma6.enable = true;

  ### hyprland ###
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    #WLR_NO_HARDWARE_CURSORS = "1";  # if cursor disappears
  };

  fonts = {
    packages = with pkgs; [
	# icon fonts
	material-design-icons

	# normal fonts
	noto-fonts
	noto-fonts-cjk-sans
	noto-fonts-emoji

	# nerd fonts
	nerd-fonts.jetbrains-mono
    ];

    enableDefaultPackages = false; # use fonts defined by user

    # user defined fonts
    fontconfig.defaultFonts = {
	serif = ["Noto Serif" "Noto Color Emoji"];
	sansSerif = ["Noto Sans" "Noto Color Emoji"];
	monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
	emoji = ["Noto Color Emoji"];
    };
  };



  networking.hostName = "nixos";

  networking.networkmanager.enable = true;

  users.users = {
    KenJolno = {
      isNormalUser = true;
      home = "/home/KenJolno";
      description = "KenJolno";
      openssh.authorizedKeys.keys = [
        SHA256:QglmcEd2plxiiGH/G7ffj5dPrcKFI1ac/PTwamBARAs
      ];
      extraGroups = ["wheel" "networkmanager"];
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = false;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
