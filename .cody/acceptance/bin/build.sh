#!/bin/bash

final_status=0
function capture_status {
  if [ "$?" -ne "0" ] && [ $final_status -ne 1 ] ; then
    final_status=1
  fi
}

set -eu
# will build from /tmp because terraspace/Gemfile may interfere
cd /tmp
export PATH=~/bin:$PATH # ~/bin/lono wrapper

lono new project infra
cd infra

# Rewrite the Gemfile to use the local lono gem for testing
cat << EOF > Gemfile
source "https://rubygems.org"
gem "lono", path: "$CODEBUILD_SRC_DIR", submodules: true
gem "rspec-lono", git: "https://github.com/boltops-tools/rspec-lono", branch: "master"
EOF
cat Gemfile

bundle # install lono gem in the infra project

export LONO_ENV="test-$(date +%Y%m%d%H%M%S)"
lono new blueprint demo --examples

# Continue on error and capture final exit status so lono down always and cleans up stack
set +e
# Test new stack creation
lono up demo -y
capture_status

lono seed demo # just to test it. will overwrite file
capture_status

# Test stack update
cat << EOF > config/blueprints/demo/params/$LONO_ENV.txt
AccessControl=PublicRead
EOF
lono up demo -y
capture_status

# Clean up resources
lono down demo -y
capture_status
set -e

exit $final_status
