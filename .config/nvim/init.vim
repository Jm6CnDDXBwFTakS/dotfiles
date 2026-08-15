source ~/.config/vim/vimrc

if exists("g:neovide")
  source ~/.config/vim/gvimrc

  map! <S-Insert> <C-R>+
  nmap <S-Insert> p
endif
