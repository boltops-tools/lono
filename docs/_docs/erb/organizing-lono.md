---
title: Organizing Lono
categories: erb
nav_order: 93
---

## Breaking up app/definitions

If you have a lot of templates, the `app/definitions/base.rb` file can become unwieldy long.  You can break up the file and put them under the `app/definitions/base` folder. All files are loaded.

Though, you might find that using a balance of [shared variables]({% link _docs/configs/shared-variables.md %}), [params]({% link _docs/configs/params.md %}), and native CloudFormation constructs, and [layering]({% link _docs/core/layering.md %}) results in a short `app/definitions` files and you don't break up your `app/definitions` files in the first place.

{% include prev_next.md %}
