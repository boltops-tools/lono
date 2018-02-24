---
title: lono user_data
---

```
Usage:
  lono user_data NAME

Options:
  [--clean], [--no-clean]  # remove all output/user_data files before generating
                           # Default: true
```

Generates user_data scripts in `app/user_data` so you can see it for debugging. Let's say you have a script in `app/user_data/bootstrap.sh`. To generate it:

    lono user_data bootstrap
