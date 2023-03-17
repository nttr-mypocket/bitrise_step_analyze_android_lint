#!/bin/bash
set -ex

# Install RVM if it's not already installed
if [[ ! -s "$HOME/.rvm/scripts/rvm" ]]; then
  \curl -sSL https://get.rvm.io | bash -s stable
fi

ruby_version=2.7.5

source "$HOME/.rvm/scripts/rvm"

rvm install $ruby_version
rvm use $ruby_version

ruby --version