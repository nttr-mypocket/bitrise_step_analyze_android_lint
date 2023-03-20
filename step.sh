#!/bin/bash
set -ex

git clone https://github.com/nttr-mypocket/bitrise_step_analyze_android_lint.git test-folder

# Print the current folder
echo "Current folder: $(pwd)"
# Print the files and folders in the current directory
echo "Files and folders in the current directory:"
ls

chmod +x ./shell/prepare-lint-variables.sh
source ./shell/prepare-lint-variables.sh

chmod +x ./shell/install-ruby.sh
source ./shell/install-ruby.sh

ruby ./ruby/android-lint.rb
