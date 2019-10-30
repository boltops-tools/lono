---
title: Upgrading Guide
categories: extras
nav_order: 64
---

Upgrading Lono to some releases may require some extra changes. For example, the Lono project structure can change between major versions. This page provides a summary of the releases requiring some upgrade work.

## Upgrading Summary

The following table summarizes the releases and upgrade paths.

Version | Notes | Upgrade Command
--- | --- | ---
5.0 | Major project structural changes to introduce blueprints concept  | lono upgrade v4to5
4.2 | Change settings.yml structure.  | lono upgrade v3to4_2
4.0 | Major project structural changes to better organize app folder  | lono upgrade v3to4

Though the upgrade commands are designed to be idempotent and should be safe to run, you should create a backup of the project before running them. You run the upgrade command from within your lono project.

## Upgrade Details

The following section provides a little more detail on each version upgrade. Note, not all versions required more details.

### 5.0

Major structural changes were made with v5. The standalone lono project in v4 is essentially a blueprint is v5. When you run the `lono upgrade v4to5`:

* It moves all the files in the current lono project folder to a newly created `blueprints/main` folder.
* It also moves the previous `config/params` and `config/variables` to a top-level `configs/main` folder.

The `lono upgrade v4to5` updates the structure to it's best ability. It cannot completely infer the new `configs` structure. You will likely need to do some restructuring of the params files in `configs/main` since params lookup in v5 is more powerful.  Refer to the [Lookup Precedence Params]({% link _docs/lookup-locations/params.md %}) docs.

{% include prev_next.md %}
