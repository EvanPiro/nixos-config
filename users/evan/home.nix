{pkgs, ...}: {
  home.stateVersion = "22.05";
  home.username = "evan";
  home.homeDirectory = "/home/evan";
  home.file.".inputrc".text = ''
    "\e[A": history-search-backward
    "\e[B": history-search-forward
  '';

  home.sessionVariables.EDITOR = "vim";
  programs.bash.sessionVariables.EDITOR = "vim";
}
