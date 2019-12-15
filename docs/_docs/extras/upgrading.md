---
title: Upgrading Guide
categories: extras
nav_order: 81
---

Upgrading Lono to some releases may require some extra changes. For example, the Lono project structure can change between major versions. This page provides a summary of the releases requiring some upgrade work.

## Upgrading Summary

The following table summarizes the releases and upgrade paths.

Version | Notes
--- | ---
7.0 | Project structural change: project blueprints moved from `blueprints` to `app/blueprints`.
5.0 | Major project structural changes to introduce blueprints concept.
4.2 | Change settings.yml structure.
4.0 | Major project structural changes to better organize app folder.

## lono upgrade command

Though the [lono upgrade]({% link _reference/lono-upgrade.md %}) command is designed to be idempotent and should be safe to run, you should create a backup of the project before running them. You run the upgrade command from within your lono project.

## Upgrade Details

The following section provides a little more detail on each version upgrade. Note, not all versions required more details.

### 7.0

* Project blueprints moved from `blueprints` to `app/blueprints`
* You can use use the [lono upgrade]({% link _reference/lono-upgrade.md %}) to upgrade from v6 to v7.
* Removed old lono upgrade subcommands in favor of one `lono upgrade`. New upgrade command only works from v6 onward.

### 5.0

Major structural changes in v5. The standalone lono project in v4 is essentially a blueprint is v5. When you run the `lono upgrade v4to5`:

* It moves all the files in the current lono project folder to a newly created `blueprints/main` folder.
* It also moves the previous `config/params` and `config/variables` to a top-level `configs/main` folder.

{% include prev_next.md %}
