{ config, pkgs, inputs, ... }:

{
	i18n.inputMethod = {
		type = "fcitx5";
		enable = true;
		fcitx5 = {
			waylandFrontend = true;
			addons = with pkgs; [
				fcitx5-gtk
				fcitx5-chinese-addons
				fcitx5-configtool
				fcitx5-rime
			];
		};
	};
}
