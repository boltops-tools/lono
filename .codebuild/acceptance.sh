#!/bin/bash

set -exu

# https://unix.stackexchange.com/questions/1496/why-doesnt-my-bash-script-recognize-aliases
shopt -s expand_aliases
alias lono="$(pwd)/exe/lono"

bundle install --without development test
# bundle install --path vendor/bundle

rm -rf infra

lono new infra
# Very simply template with just a security group
cp .codebuild/demo.rb infra/blueprints/demo/app/templates/demo.rb
cd infra

STACK_NAME="demo-$(date +%Y%m%d%H%M%S)"

lono cfn deploy $STACK_NAME --blueprint demo
lono cfn status $STACK_NAME
lono cfn delete $STACK_NAME --sure
