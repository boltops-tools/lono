# Overview

CodeBuild is used to run **acceptance-level tests**.

## Deploy Project

To update the CodeBuild project that handles deployment:

    cody deploy lono -t acceptance

## Start Build

To start a CodeBuild build:

    cody start lono -t acceptance

To specify a branch:

    cody start lono -t acceptance -b feature
