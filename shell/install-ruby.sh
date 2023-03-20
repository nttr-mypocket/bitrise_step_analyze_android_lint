#!/bin/bash
set -ex

# Install Ruby
apt-get update
apt-get install -y ruby

ruby --version