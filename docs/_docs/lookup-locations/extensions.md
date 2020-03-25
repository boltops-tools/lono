---
title: Extensions Lookup Locations
nav_text: Extensions
category: lookup
order: 6
nav_order: 84
---

Extensions allow you extend to the Lono DSL and can be shareable between multiple blueprints.  Extensions are searched for in a few locations. It is similiar to how `LOAD_PATH` works.

Location | Type | Description
--- | --- | ---
PROJECT/app/extensions | project | The project's local extensions
PROJECT/vendor/extensions | vendor | Frozen vendor extensions
gems folder | gem | The gems folder is the location where the extension gem is installed. You can use `bundle show GEM` to reveal the location.
gems folder | materialized | All blueprint extensions will materialize if they are not found in the earlier lookup locations.

## lono extensions BLUEPRINT command

The [lono extensions BLUEPRINT]({% link _reference/lono-extensions.md %}) command provides a quick way to find out what extensions are used by a specific blueprint.

    $ lono extensions asg-worker
    extensions used by asg-worker blueprint:
    +----------------+-------------------------------+---------+---------+
    |     Name       |             Path              |  Type   |  From   |
    +----------------+-------------------------------+---------+---------|
    | asg_extensions | app/extensions/asg_extensions | project | project |
    +----------------+-------------------------------+---------+---------+
    $

## Materialized Extensions

Blueprints can make use of extensions. Usually the extensions will be within your own project under `app/extensions`, `vendor/extensions` or in your Gemfile.  If the extension used by the blueprint is not found in one of those locations, lono will materialize the extension and download it. These are known as "materialized" extensions.

{% include prev_next.md %}
