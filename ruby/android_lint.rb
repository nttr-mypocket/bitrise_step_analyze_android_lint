# Copyright © 2023 NTT Resonant Technology Inc. All Rights Reserved.

# frozen_string_literal: true

require 'rexml/document'
require 'logger'

# Issue構造体の定義
Issue = Struct.new(
  :id, 
  :severity,
  :message,
  :category,
  :priority,
  :summary,
  :explanation,
  :errorLine1,
  :errorLine2,
  :location
)

# Location構造体の定義
Location = Struct.new(
  :file,
  :line,
  :column
)

# エラーのカウントを出力する関数
def print_error_counts(logger, error_count, fatal_count, ignore_count, informational_count, warning_count)
  logger.info("error count: #{error_count}")
  logger.info("fatal count: #{fatal_count}")
  logger.info("ignore count: #{ignore_count}")
  logger.info("informational count: #{informational_count}")
  logger.info("warning count: #{warning_count}")
end

# Locationオブジェクトを生成する関数
def build_location(xml_element)
  location_element = xml_element.elements['location']
  Location.new(
    location_element.attributes['file'],
    location_element.attributes['line'],
    location_element.attributes['column']
  )
end

# ロガーを設定する
logger = Logger.new($stderr)

# Lintの出力ファイルを取得する
xml_file = ENV["LINT_XML_OUTPUT"]
logger.info("Input XML: #{xml_file}")

# エラーの種類ごとにカウントするための変数を初期化する
error_count  = 0
fatal_count  = 0
ignore_count = 0
informational_count = 0
warning_count = 0

# Lintの出力ファイルをパースして問題を取得する
begin
  doc = REXML::Document.new(File.open(xml_file))
  doc.elements.each('//issues/issue') do |issue_element|
    # XML要素からIssueオブジェクトを作成する
    issue = Issue.new(
      issue_element['id'],
      issue_element['severity'],
      issue_element['message'],
      issue_element['category'],
      issue_element['priority'],
      issue_element['summary'],
      issue_element['explanation'],
      issue_element['errorLine1'],
      issue_element['errorLine2'],
      build_location(issue_element)
    )

    # エラーの種類ごとにカウントする
    if 'error'.casecmp(issue.severity).zero?
      error_count  += 1
    elsif 'fatal'.casecmp(issue.severity).zero?
      fatal_count  += 1
    elsif 'ignore'.casecmp(issue.severity).zero?
      ignore_count += 1
    elsif 'informational'.casecmp(issue.severity).zero?
      informational_count += 1
    elsif 'warning'.casecmp(issue.severity).zero?
      warning_count += 1
    end

  end
rescue StandardError => e
  # ファイルのオープンに失敗した場合はエラーをログに出力して終了する
  logger.error("File Open Failed: #{xml_file}, Error: #{e.message}")
  exit(1)
end

# エラーの種類ごとにカウントした結果をログに出力する
print_error_counts(logger, error_count, fatal_count, ignore_count, informational_count, warning_count)

# エラーの種類ごとにカウントした結果をログに出力する
system( "envman add --key LINT_OUTPUT_ERROR --value #{error_count}" )
system( "envman add --key LINT_OUTPUT_FATAL --value #{fatal_count}" )
system( "envman add --key LINT_OUTPUT_IGNORE --value #{ignore_count}" )
system( "envman add --key LINT_OUTPUT_INFO --value #{informational_count}" )
system( "envman add --key LINT_OUTPUT_WARNING --value #{warning_count}" )

# エラーカウントがある場合、エラーログを出力し、スクリプトを終了する
if error_count.positive? || fatal_count.positive?
  logger.error("Fatal or Error count： #{error_count + fatal_count}")
  exit(2)
end