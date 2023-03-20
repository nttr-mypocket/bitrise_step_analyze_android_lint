# frozen_string_literal: true

require 'rexml/document'
require 'logger'

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

Location = Struct.new(
  :file,
  :line,
  :column
)

def print_error_counts(logger, error_count, fatal_count, ignore_count, informational_count, warning_count)
  logger.info("error count: #{error_count}")
  logger.info("fatal count: #{fatal_count}")
  logger.info("ignore count: #{ignore_count}")
  logger.info("informational count: #{informational_count}")
  logger.info("warning count: #{warning_count}")
end

def build_location(xml_element)
  location_element = xml_element.elements['location']
  Location.new(
    location_element.attributes['file'],
    location_element.attributes['line'],
    location_element.attributes['column']
  )
end

logger = Logger.new($stderr)

Dir.entries('../..').each do |filename|
  puts filename
end

xml_file = ENV["LINT_XML_OUTPUT_RUBY"]
logger.info("INPUT XML: #{xml_file}")

error_count  = 0
fatal_count  = 0
ignore_count = 0
informational_count = 0
warning_count = 0

begin
  doc = REXML::Document.new(File.open(xml_file))
  doc.elements.each('//issues/issue') do |issue_element|
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
  logger.error("Failed to open XML file: #{xml_file}")
  logger.error("Error: #{e.message}")
  exit(1)
end

print_error_counts(logger, error_count, fatal_count, ignore_count, informational_count, warning_count)

system( "envman add --key LINT_OUTPUT_ERROR --value #{error_count}" )
system( "envman add --key LINT_OUTPUT_FATAL --value #{fatal_count}" )
system( "envman add --key LINT_OUTPUT_IGNORE --value #{ignore_count}" )
system( "envman add --key LINT_OUTPUT_INFO --value #{informational_count}" )
system( "envman add --key LINT_OUTPUT_WARNING --value #{warning_count}" )

if error_count.positive? || fatal_count.positive?
  logger.error("Critical errors count : #{error_count + fatal_count}")
  exit(2)
end