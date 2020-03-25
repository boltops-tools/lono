---
title: 'Configset Helper: content_file'
---

The `content_file` helper reads the file in the configsets `lib/content` folder and returns it as a String. This helps you organized things and keep the [file]({% link _docs/configsets/dsl/file.md %}) method readable.

## Example

lib/files/script.sh:

    #!/bin/bash
    echo hello

lib/configset.rb:

```ruby
file("/tmp/myfile2.txt",
  content: content_file("script.sh"), # uses lib/files/script.sh
  mode: "120644",
)
```