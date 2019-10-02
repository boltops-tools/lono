#!/bin/bash

set -exu

# https://unix.stackexchange.com/questions/1496/why-doesnt-my-bash-script-recognize-aliases
shopt -s expand_aliases
alias bolt="$(pwd)/exe/bolt"

bundle install --without development test

rm -rf infra

bolt new infra
# Very simply template with just a security group
cp .codebuild/demo.rb infra/blueprints/demo/app/templates/demo.rb
cd infra

# Rewrite the Gemfile to use the local bolt gem for testing
cat << EOF > Gemfile
source "https://rubygems.org"
gem "bolt", path: "$CODEBUILD_SRC_DIR", submodules: true
EOF

bundle # install bolt gem in the infra project

STACK_NAME="demo-$(date +%Y%m%d%H%M%S)"

bolt cfn deploy $STACK_NAME --blueprint demo
bolt cfn status $STACK_NAME
bolt cfn delete $STACK_NAME --sure
