{pkgs, ...}: {
  home.stateVersion = "22.05";
  home.username = "evan";
  home.homeDirectory = "/home/evan";
  home.file.".inputrc".text = ''
    "\e[A": history-search-backward
    "\e[B": history-search-forward
  '';
  home.file.".vimrc".text = ''
    syntax on
    filetype plugin indent on
  '';

  home.sessionVariables.EDITOR = "vim";
  programs.bash.sessionVariables.EDITOR = "vim";
  programs.neovim =
    { enable = true;
      vimAlias = true;
      extraConfig = "source ${./init.vim}";

      coc= {
        enable = true;
        settings.languageserver= {
            purescript= {
              command= "purescript-language-server";
              args= ["--stdio"];
              filetypes= ["purescript"];
              rootPatterns= ["output"];
              trace.server= "off";
              settings= {
                purescript= {
                  addSpagoSources= true;
                  addNpmPath= true;
                };
              };
            };
            haskell= {
              command= "haskell-language-server";
              args= ["--lsp"];
              filetypes= ["hs" "lhs" "haskell" "lhaskell"];
              rootPatterns= ["*.cabal" "stack.yaml" "cabal.project" "package.yaml"  "hie.yaml"];
              initializationOptions.languageServerHaskell.hlintOn=true;
            };
          };
        };

        plugins = with pkgs.vimPlugins;
          let
            vim-j = pkgs.vimUtils.buildVimPlugin
              { name = "vim-j";
                src = pkgs.fetchFromGitHub {
                  owner = "EvanPiro";
                  repo = "vim-j";
                  rev = "dcf2357339fbe1b7ac4125a323dbe0f8ff4937cc";
                  sha256 = "sha256-QSM8tR2RtL34lBqzn3pifO73qsLroZyPEiFsW/Hn/KI=";
                };
              };
          in
          [ syntastic
            airline
            commentary
            haskell-vim
            purescript-vim
            surround
            nerdtree
            vimwiki
            hoogle
            vim-nix
            vim-j
          ];
     };
}
