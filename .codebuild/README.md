# CodeBuild Cheatsheet

Command to kick off build:

    aws codebuild start-build --project-name lono-acceptance # master branch
    aws codebuild start-build --project-name lono-acceptance --source-version another-branch
