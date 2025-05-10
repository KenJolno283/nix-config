{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    ## file manager ##
    yazi
    kdePackages.dolphin

    ## archives ##
    zip
    unzip

    ## utils ##
    ripgrep

    ## misc ##
    cowsay
    file
    which
    lsd
    gnused
    gnutar
    gawk
    zstd
    gnupg
    cava

    ## productivity ##
    hugo
    glow # markdown previewer
    btop
    iotop
    iftop

    ## multimedia ##
    amberol # music
    smplayer # video
    mcomix # comic
    lutris # game

    ## social ##
    telegram-desktop
    thunderbird

    ## system tools ##
    sysstat
    lm_sensors
    ethtool
    pciutils
    usbutils
  ];
}
