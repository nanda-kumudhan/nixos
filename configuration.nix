{ config, pkgs, lib, ... }:

{

  imports = [
      ./hardware-configuration.nix
    ];

  ############################################################
  # Boot
  ############################################################

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages;

  ############################################################
  # Networking
  ############################################################

  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openconnect
    networkmanager-openvpn
    networkmanager-vpnc
  ];

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 53317 ]; # LocalSend
  networking.firewall.allowedUDPPorts = [ 53317 ]; # LocalSend

  ############################################################
  # Localization
  ############################################################

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  console.keyMap = "uk";
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  ############################################################
  # Sway Desktop Environment
  ############################################################

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      autotiling foot grim htop imv mako mpv
      networkmanagerapplet nwg-look brightnessctl
      pavucontrol polkit_gnome rofi slurp swaybg swayidle
      swaylock thunar waybar wdisplays wf-recorder
      wl-clipboard zathura
    ];
  };

  ############################################################
  # Desktop Portals (screen sharing, file pickers)
  ############################################################

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
    config.sway = {
      default = [ "gtk" ];
      "org.freedesktop.portal.ScreenCast" = [ "wlr" "gtk" ];
    };
  };

  xdg.portal.wlr.settings.screencast = {
    chooser_type = "simple";
    chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
  };

  ############################################################
  # Hardware
  ############################################################

  hardware.graphics.enable = true;
  hardware.sane.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  ############################################################
  # Security
  ############################################################

  security.polkit.enable = true;
  security.tpm2.enable = true;
  security.rtkit.enable = true;

  security.apparmor.enable = true;
  security.apparmor.packages = [ pkgs.apparmor-profiles ];
  security.apparmor.killUnconfinedConfinables = true;

  programs.ssh.startAgent = true;
  systemd.user.services.ssh-agent.enable = false;
  systemd.user.sockets.ssh-agent.enable = false;

  ############################################################
  # Services
  ############################################################

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  services.tailscale.enable = true;
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;

  services.logind.settings.Login = {
    HandlePowerKey = "suspend";
    IdleAction = "suspend";
    IdleActionSec = "10min";
  };

  ############################################################
  # Virtualisation
  ############################################################

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  programs.virt-manager.enable = true;

  ############################################################
  # Environment
  ############################################################

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    anki antimicrox brave discord gh
    cargo curl distrobox engrampa github-copilot-cli spice spice-gtk spice-protocol
    fastfetch firefox gcc git gdb jq jupyter keepassxc libreoffice-fresh
    localsend lswt mullvad-browser nano nodejs openconnect openssh
    openvpn papirus-icon-theme prismlauncher python3 qemu
    remmina rustc rpi-imager sbctl spotify transmission_4-gtk tor torsocks
    tor-browser tree vim vscodium wget wireguard-tools yt-dlp zed-editor
    gruvbox-dark-gtk proton-vpn-cli python3Packages.ipython python3Packages.pip
    python3Packages.virtualenv maven gradle jdk gnome-disk-utility
  ];

  programs.nix-ld.enable = true;

  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  ############################################################
  # Users
  ############################################################

  users.users."nanda-kumudhan" = {
    isNormalUser = true;
    description = "Nanda Kumudhan";
    hashedPassword = "$6$jJ9v.1SlIoEpJzKQ$t1./4aONTxloD3.XLrGG8J4d7dh8eQAtG5Y9Q03G2QOg/wVGbDuRZGQwNUzEUWFsdRFW9mZhws3VU9BQBdT..0";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "kvm" "dialout" "adbusers"];
  };

  programs.starship.enable = true;
  system.stateVersion = "26.05";

  ############################################################
  # Display Manager (Console/TUI Login into Sway)
  ############################################################

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # Boots tuigreet directly into your Sway setup with a clean layout
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --asterisks";
        user = "greeter";
      };
    };
  };

  # Ensures tuigreet graphical session handles standard PAM environments correctly
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  ############################################################
  # Laptop Power Management
  ############################################################

  services.tlp.enable = true;

  networking.hostName = "nanda-desktop";

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  nix.settings.auto-optimise-store = true;
  nix.optimise.automatic = true;

  services.fstrim.enable = true;

  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
  };

  boot.loader.systemd-boot.extraInstallCommands = ''
    ${pkgs.sbctl}/bin/sbctl sign-all || true
  '';

}
