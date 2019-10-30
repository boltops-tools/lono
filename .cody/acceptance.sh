#!/bin/bash

set -exu

# https://unix.stackexchange.com/questions/1496/why-doesnt-my-bash-script-recognize-aliases
shopt -s expand_aliases
alias lono="$(pwd)/exe/lono"

bundle install --without development test

rm -rf infra

lono new infra
cd infra
lono blueprint new demo
# Very simply template with just a security group
cp ../.cody/demo.rb blueprints/demo/app/templates/demo.rb

# Rewrite the Gemfile to use the local lono gem for testing
cat << EOF > Gemfile
source "https://rubygems.org"
gem "lono", path: "$CODEBUILD_SRC_DIR", submodules: true
EOF

bundle # install lono gem in the infra project

STACK_NAME="demo-$(date +%Y%m%d%H%M%S)"

lono cfn deploy $STACK_NAME --blueprint demo
lono cfn status $STACK_NAME
lono cfn delete $STACK_NAME --sure
