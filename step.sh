#!/bin/bash

# Copyright © 2023 NTT Resonant Technology Inc. All Rights Reserved.

set -ex
set +x
set +v

echo "Print Environments"
echo "  target_project_location: $target_project_location"
echo "  target_module: $target_module"
echo "  build_variant: $build_variant"
echo "  step_repository_url: $step_repository_url"
echo "  step_clone_dir_branch: $step_clone_dir_branch"
echo "  step_branch: $step_branch"

echo "Start Android Lint"
./gradlew :app:lint${build_variant}

echo "Generate Environments"
scripts_dir=$step_clone_dir_branch
lint_module=$target_module
variant=$build_variant
file_loc=${target_project_location}/${lint_module}/build/reports/lint-results-${variant}

echo "  scripts_dir: $scripts_dir"
echo "  lint_module: $lint_module"
echo "  variant: $variant"
echo "  file_loc: $file_loc"

# export
export LINT_XML_OUTPUT=${file_loc}.xml
export LINT_HTML_OUTPUT=${file_loc}.html

# ステップのリポジトリをクローンする
echo "Prepare Scripts file, with Git Clone. Dir: $scripts_dir"
if [ -d "$scripts_dir" ]; then
  echo "Directory '$scripts_dir' already exists."
else
  echo "Cloning branch '$step_branch' from repository '$step_repository_url' to directory '$scripts_dir'..."
  git clone -b "$step_branch" "$step_repository_url" "$scripts_dir"
fi
echo "Prepared Scripts file."

# 環境変数を設定する
envman add --key LINT_XML_OUTPUT --value "${LINT_XML_OUTPUT}"
envman add --key LINT_HTML_OUTPUT --value "${LINT_HTML_OUTPUT}"

echo "Start Lint Analyze"
# rubyを実行する
ruby ./"${scripts_dir}"/ruby/android_lint.rb

echo "Complete Lint Analyze"