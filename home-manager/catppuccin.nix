{ inputs, pkgs, ... }:

{
  imports = [ inputs.catppuccin.homeModules.catppuccin ];

  gtk = {
    theme = {
      package = pkgs.fluent-gtk-theme;
      name = "fluent-gtk-theme";
    };
    iconTheme = {
      package = pkgs.fluent-icon-theme;
      name = "fluent-icon-theme";
    };
    cursorTheme = {
      package = pkgs.catppuccin-cursors.frappeSapphire;
      name = "catppuccin-cursors.frappeSapphire";
    };
  };

  catppuccin = {
    enable = true;
    flavor = "frappe";
  };
}
