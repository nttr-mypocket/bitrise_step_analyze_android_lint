#!/bin/bash
set -ex

loc=$PROJECT_LOCATION
lint_module=$MODULE
variant=$VARIANT

loc=${loc}/${lint_module}/build/reports
xml_loc=${loc}/lint-results-${variant}.xml
html_loc=${loc}/lint-results-${variant}.html

envman add --key LINT_XML_OUTPUT --value $xml_loc
envman add --key LINT_HTML_OUTPUT --value $html_loc

# Set the path to the lint XML output file
xml_file=$LINT_XML_OUTPUT

# check if xml_file is not empty
if [ -z "$xml_file" ]
then
    echo "LINT_XML_OUTPUT is empty"
    exit 1
fi

echo "INPUT XML: $xml_file"

error_count=0
fatal_count=0
ignore_count=0
informational_count=0
warning_count=0

while IFS= read -r line; do
  if [[ "$line" =~ severity=\"Error\" ]]; then
    ((error_count++))
  elif [[ "$line" =~ severity=\"Warning\" ]]; then
    ((warning_count++))
  elif [[ "$line" =~ severity=\"Informational\" ]]; then
    ((informational_count++))
  elif [[ "$line" =~ severity=\"Ignore\" ]]; then
    ((ignore_count++))
  elif [[ "$line" =~ severity=\"Fatal\" ]]; then
    ((fatal_count++))
  fi
done < "$xml_file"

# print error counts
echo "error count: $error_count"
echo "fatal count: $fatal_count"
echo "ignore count: $ignore_count"
echo "informational count: $informational_count"
echo "warning count: $warning_count"

# Export the error counts as environment variables using envman
envman add --key LINT_OUTPUT_ERROR --value "$error_count"
envman add --key LINT_OUTPUT_FATAL --value "$fatal_count"
envman add --key LINT_OUTPUT_IGNORE --value "$ignore_count"
envman add --key LINT_OUTPUT_INFO --value "$informational_count"
envman add --key LINT_OUTPUT_WARNING --value "$warning_count"

# Exit with an error code if there are critical errors
if [ $((error_count + fatal_count)) -gt 0 ]; then
  echo "Critical errors count : $((error_count + fatal_count))"
  exit 2
fi
