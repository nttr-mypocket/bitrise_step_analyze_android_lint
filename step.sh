#!/bin/bash
set -ex

git clone https://github.com/nttr-mypocket/bitrise_step_analyze_android_lint.git test-folder

# Print the current folder
echo "Current folder: $(pwd)"
# Print the files and folders in the current directory
echo "Files and folders in the current directory:"
ls

chmod +x ./test-folder/shell/prepare-lint-variables.sh
source ./test-folder/shell/prepare-lint-variables.sh

chmod +x ./test-folder/shell/install-ruby.sh
source ./test-folder/shell/install-ruby.sh

ruby ./test-folder/ruby/android-lint.rb
