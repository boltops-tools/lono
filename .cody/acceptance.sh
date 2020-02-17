#!/bin/bash

gem install bundler # upgrade bundler

set -exu

git config --global user.email "tonguerooo@gmail.com"
git config --global user.name "tung"

# https://unix.stackexchange.com/questions/1496/why-doesnt-my-bash-script-recognize-aliases
shopt -s expand_aliases
alias lono="$(pwd)/exe/lono"

bundle install --without development test

rm -rf infra

lono new infra
cd infra

# Rewrite the Gemfile to use the local lono gem for testing
cat << EOF > Gemfile
source "https://rubygems.org"
gem "lono", path: "$CODEBUILD_SRC_DIR", submodules: true
EOF
cat Gemfile

bundle # install lono gem in the infra project

# Create a demo blueprint
lono blueprint new demo
# Very simply template with just a security group
cp ../.cody/demo.rb app/blueprints/demo/app/templates/demo.rb

STACK_NAME="demo-$(date +%Y%m%d%H%M%S)"

# Configure lono registration
mkdir -p .lono
cat << EOF > .lono/registration.yml
---
name: <%= ssm("/lono/registration/name") %>
company: <%= ssm("/lono/registration/company") %>
email: <%= ssm("/lono/registration/email") %>
registration_key: <%= ssm("/lono/registration/registration_key") %>
EOF

lono cfn deploy $STACK_NAME --blueprint demo
lono cfn status $STACK_NAME
lono cfn delete $STACK_NAME --sure
