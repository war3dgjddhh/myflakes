{ pkgs, ... }:
let
  install_lsp = pkgs.writeShellScriptBin "install_lsp" ''
      #!/bin/bash 
    if [ ! -d ~/.npm-global ]; then  
             mkdir ~/.npm-global
             npm set prefix ~/.npm-global
      else 
             npm set prefix ~/.npm-global
    fi
    npm i -g npm vscode-langservers-extracted typescript typescript-language-server bash-language-server
  '';
in
{
  environment.systemPackages = [
    pkgs.vimPlugins.packer-nvim
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home.file.".config/nvim/lua".source = ./nvim/lua;
  home.file.".config/nvim/start.lua".source = ./nvim/init.lua;
  programs = {
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      withPython3 = true;
      withNodeJs = true;
      extraConfig = ''
        luafile ~/.config/nvim/start.lua
      '';
    };
  };

  home = {
    packages = with pkgs; [
      #-- LSP --#
      install_lsp
      rnix-lsp
      sumneko-lua-language-server
      gopls
      pyright
      zk
      rust-analyzer
      clang-tools
      #-- tree-sitter --#
      tree-sitter
      #-- format --#
      stylua
      black
      nixpkgs-fmt
      rustfmt
      beautysh
      nodePackages.prettier
      #-- Debug --#
      lldb
      #-- Neovim deps --#
      git
      curl
      wget
      unzip
      #-- GCC deps --#
      gcc
      #-- telescope live grep --#
      ripgrep
    ];
  };
}


