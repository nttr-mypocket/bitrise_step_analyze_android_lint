#!/bin/bash
set -ex
set +x
set +v

folder=$step_clone_dir_branch

# ステップのリポジトリをクローンする
git clone -b $step_branch $step_repository_url $folder

loc=$target_project_location
lint_module=$target_module
variant=$build_variant

# lintの実行結果を保存するファイルのパスを設定する
loc=${loc}/${lint_module}/build/reports
file_loc=${loc}/lint-results-${variant}

# 環境変数を設定する
export LINT_XML_OUTPUT=${file_loc}.xml
export LINT_HTML_OUTPUT=${file_loc}.html
envman add --key LINT_XML_OUTPUT --value ${file_loc}.xml
envman add --key LINT_HTML_OUTPUT --value ${file_loc}.html

# rubyを実行する
ruby ./${folder}/ruby/android-lint.rb
