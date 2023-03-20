#!/bin/bash
set -ex
set +x
set +v

loc=$PROJECT_LOCATION
lint_module=$MODULE
variant=$VARIANT

loc=${loc}/${lint_module}/build/reports
file_loc=${loc}/lint-results-${variant}

export LINT_XML_OUTPUT=${file_loc}.xml
export LINT_HTML_OUTPUT=${file_loc}.html

envman add --key LINT_XML_OUTPUT --value $xml_loc
envman add --key LINT_HTML_OUTPUT --value $html_loc

echo $LINT_XML_OUTPUT
echo $LINT_HTML_OUTPUT