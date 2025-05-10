{ pkgs, lib, inputs,... }:

{
  imports = [
    inputs.nvf.homeManagerModules.default
  ];

  # vim = {
    # package = pkgs.neovim-unwrapped;
    # theme = {
      # enable = true;
      # name = "catppuccin";
      # style = "dark";
    # };

    # statusline.lualine.enable = true;
    # telescope.enable = true;
    # autocomplete.nvim-cmp.enable = true;

    # languages = {
      # enableLSP = true;
      # enableTreesitter = true;

      # nix.enable = true;
      # python.enable = true;
      # markdown.enable = true;
    # };
  # };
}
