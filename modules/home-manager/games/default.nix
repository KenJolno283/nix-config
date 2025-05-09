{ pkgs, inputs, outputs, config, ... }:

{
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
}
