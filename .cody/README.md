# Cody Files

The files in folder are used by cody to build AWS CodeBuild projects.  For more info, check out the [cody docs](https://cody.run). Here's a quick start.

## Install Tool

    gem install cody

This installs the `cody` command to manage the AWS CodeBuild project.

## Update Project

To update the CodeBuild project that handles deployment:

    cody deploy lono

## Start a Deploy

To start a CodeBuild build:

    cody start lono

To specify a branch:

    cody start lono -b feature
