#!/bin/sh
GitSet="git config --global "

echo "Git [core] settings"
$GitSet core.autocrlf            false
$GitSet core.safecrlf            true
$GitSet core.filemode            false
$GitSet core.deltaBaseCacheLimit 16
$GitSet core.editor              vim
$GitSet core.preloadindex        true
$GitSet core.fscache             true

echo "Git [alias] settings"
$GitSet alias.change-commits     "!f() { VAR=$1; OLD=$2; NEW=$3; shift 3; git filter-branch --env-filter \"if [[ $`echo $VAR` = \\\"$OLD\\\" ]]; then export $VAR=\\\"$NEW\\\"; fi\" $@; }; f "
$GitSet alias.lg                 "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"

echo "Git [help] settings"
$GitSet help.autocorrect         1

echo "Git [push] settings"
$GitSet push.default             tracking

echo "Git [credential] settings"
$GitSet credential.helper        cache

echo "Git [gc] settings"
$GitSet gc.auto                  256
