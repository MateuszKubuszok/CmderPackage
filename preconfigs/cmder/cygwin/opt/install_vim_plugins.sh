#!/bin/sh
Vim=~/.vim

function GitHubRepo {
  Source=https://github.com/$1/$2
  Repo=$Vim/repo/$2

  if [ ! -d "$Repo/.git" ]; then
    git clone $Source $Repo \
      --config core.autocrlf=false \
      --config core.safecrlf=true \
      --config core.eol=lf
  else
    cd $Repo
    git fetch --all
    git reset --hard origin/master
  fi
}

function InstallInto {
  Repo=$Vim/repo/$2

  GitHubRepo $1 $2
  mkdir -p $3
  cp -r $Repo/. $3
  rm -rf $3/.git $3/.gitignore $3/README*
}

function BundleInstall {
  Bundle="$Vim/bundle/$2"
  InstallInto $1 $2 $Bundle
}

function PlainInstall {
  InstallInto $1 $2 $Vim
}

PlainInstall  techlivezheng vim-plugin-minibufexpl

PlainInstall  tpope vim-pathogen
BundleInstall bling vim-airline
BundleInstall bling vim-bufferline
BundleInstall majutsushi tagbar
BundleInstall scrooloose nerdtree
BundleInstall scrooloose syntastic
BundleInstall sjl gundo.vim
#BundleInstall tpope vim-sensible # breaks syntax highligthing

cp -f /opt/utils/.vimrc ~/.vimrc
