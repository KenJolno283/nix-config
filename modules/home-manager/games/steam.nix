{ pkgs, inputs, outputs, ... }:

{
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
}
