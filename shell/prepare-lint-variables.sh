#!/bin/bash
set -ex
set +x
set +v

loc=$PROJECT_LOCATION
lint_module=$MODULE
variant=$VARIANT

loc=${loc}/${lint_module}/build/reports
xml_loc=${loc}/lint-results-${variant}.xml
html_loc=${loc}/lint-results-${variant}.html

export LINT_XML_OUTPUT=$xml_loc
export LINT_HTML_OUTPUT=$html_loc

echo $LINT_XML_OUTPUT
echo $LINT_HTML_OUTPUT