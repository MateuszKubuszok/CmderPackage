#!/bin/sh
mkdir -p /usr/local/bin/atom/.atom
if [ ! -d "$USERPROFILE/.atom" ]; then
  export CYGWIN="winsymlinks:lnk"
  ln -s -v /usr/local/bin/atom/.atom $USERPROFILE
fi
/usr/local/bin/atom/resources/app/apm/node_modules/atom-package-manager/bin/apm.cmd install \
  atom-grails \
  atom-runner \
  autocomplete-plus \
  build \
  build-systems \
  build-tools-cpp \
  color-picker \
  erlang-build \
  format-sql \
  git-grep \
  git-plus \
  language-ada \
  language-clojure \
  language-d \
  language-erlang \
  language-gradle \
  language-groovy \
  language-haskell \
  language-ini \
  language-lisp \
  language-ocaml \
  language-pgsql \
  language-scala \
  language-sql-mysql \
  minimap \
  minimap-find-and-replace \
  minimap-git-diff \
  minimap-highlight-selected \
  pane-move-plus \
  ruby-bundler \
  terminal-runner \
  travis-ci-status \
  vim-mode \
  Zen
