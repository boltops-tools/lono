---
title: LONO_ENV
---

Lono's behavior is controlled by the `LONO_ENV` environment variable.  For example, the `LONO_ENV` variable is used to layer different lono files together to make it easy to define multiple environments like production and development.  This is covered thoroughly in the [Layering docs]({% link _docs/layering.md %}).  `LONO_ENV` defaults to `development` when not set.

### Setting LONO_ENV

The `LONO_ENV` can be set in several ways:

1. At the CLI command invocation - This takes the highest precedence.
2. Exported as an environment variable to your shell - This takes the second highest precedence.

### At the CLI Command

```sh
LONO_ENV=production lono generate
```

### As an environment variable

```sh
export LONO_ENV=production
lono generate
```

If you do not want to remember to type `LONO_ENV=production`, you can set it in your `~/.profile`.

<a id="prev" class="btn btn-basic" href="{% link _docs/directory-structure.md %}">Back</a>
<a id="next" class="btn btn-primary" href="{% link _docs/import-template.md %}">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>
