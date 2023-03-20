#!/bin/bash
set -ex
set +x
set +v

folder="step-folder"

git clone https://github.com/nttr-mypocket/bitrise_step_analyze_android_lint.git $folder

chmod +x ./${folder}/shell/prepare-lint-variables.sh
source ./${folder}/shell/prepare-lint-variables.sh

#chmod +x ./${folder}/shell/install-ruby.sh
#source ./${folder}/shell/install-ruby.sh

ruby ./${folder}/ruby/android-lint.rb
