#!/bin/bash
set -ex
set +v

# Install Ruby
apt-get update
apt-get install -y ruby

ruby --version