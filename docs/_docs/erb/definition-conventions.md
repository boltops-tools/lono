---
title: Definition Conventions
desc: Conventions for template definition declartion
categories: erb
nav_order: 88
---

## Template Output and Source Name Convention

By convention, the template source name defaults to output name specified. Often, this means you do not have to specify the source.  For example:

```ruby
template "example" do
  source "example"
end
```

Is equivalent to:

```ruby
template "example" do
end
```

Furthermore, since the `do...end` block is empty at this point it can be removed entirely:

```ruby
template "example"
```

## Format and Extension Convention

For templates, lono assumes a format extension of `.yml`.  The format is then tacked onto the output filenames automatically when writing the final generated templates. For example:

```ruby
template "example" do
  source "example"
end
```

A `templates/example.yml` file results in creating `output/templates/example.yml` when lono generate is ran.

The extension for filenames used in partial helper is auto-detected. For example, given a partial in `templates/partials/elb.yml` a call to `partial("elb")` would automatically know to load elb.yml. As another example, given a partial in `templates/partials/script.sh`, then `partial("script")` would automatically load `script.sh`.

In the case where the extension is ambiguous, you must specify the extension explicitly. For example, given:

```sh
templates/partial/volume.sh
templates/partial/volume.yml
```

In this case, a call to `partial("volume")` is ambiguous. Which one should lono render: volume.sh or volume.yml? In this case, you must specify the extension in the helper call: `partial("volume.yml")` to remove the ambiguity.

{% include prev_next.md %}
