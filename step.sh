#!/bin/bash
set -ex

# Print the current folder
echo "Current folder: $(pwd)"

chmod +x ./shell/prepare-lint-variables.sh
source ./shell/prepare-lint-variables.sh

chmod +x ./shell/install-ruby.sh
source ./shell/install-ruby.sh

ruby ./ruby/android-lint.rb