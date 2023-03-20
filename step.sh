#!/bin/bash
set -ex

folder="step-folder"

git clone https://github.com/nttr-mypocket/bitrise_step_analyze_android_lint.git $folder

# Print the current folder
echo "Current folder: $(pwd)"
# Print the files and folders in the current directory
echo "Files and folders in the current directory:"
ls

chmod +x ./${folder}/shell/prepare-lint-variables.sh
source ./${folder}/shell/prepare-lint-variables.sh

chmod +x ./${folder}/shell/install-ruby.sh
source ./${folder}/shell/install-ruby.sh

ruby ./${folder}/ruby/android-lint.rb
