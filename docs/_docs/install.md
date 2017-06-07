---
title: Installation
---

### Bolts Toolbelt

If you want to quickly install lono without having to worry about lono's ruby dependency you can simply install the Bolts Toolbelt which has lono included.

```sh
brew tap boltopslabs/boltops
brew cask install bolts
```

For more information about the Bolts Toolbelt or to get an installer for another operating system visit: [https://boltops.com/toolbelt](https://boltops.com/toolbelt)

### RubyGems

If you already have a ruby installation.  You can also install lono via rubygems.

```sh
gem install lono
```

Or you can add lono to your Gemfile in your project if you are working with a ruby project.  It is not required for your project to be a ruby project to use lono.

{% highlight ruby %}
gem "lono"
{% endhighlight %}

<a class="btn btn-basic" href="/quick-start/">Back</a>
<a class="btn btn-primary" href="{% link _docs/directory-structure.md %}">Next Step</a>
