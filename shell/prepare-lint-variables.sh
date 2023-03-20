#!/bin/bash
set -ex
set +v

loc=$PROJECT_LOCATION
lint_module=$MODULE
variant=$VARIANT

loc=${loc}/${lint_module}/build/reports
xml_loc=${loc}/lint-results-${variant}.xml
html_loc=${loc}/lint-results-${variant}.html

envman add --key LINT_XML_OUTPUT --value $xml_loc
envman add --key LINT_HTML_OUTPUT --value $html_loc

echo $LINT_XML_OUTPUT
echo $LINT_HTML_OUTPUT