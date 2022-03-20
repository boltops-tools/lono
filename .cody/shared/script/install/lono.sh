#!/bin/bash

set -eux

export PATH=~/bin:$PATH

cat << 'EOF' > ~/.gemrc
---
:backtrace: false
:bulk_threshold: 1000
:sources:
- https://rubygems.org
:update_sources: true
:verbose: true
benchmark: false
install: "--no-ri --no-rdoc --no-document"
update: "--no-ri --no-rdoc --no-document"
EOF

gem install bundler # upgrade bundler

# In original lono source and install lono
cd $CODEBUILD_SRC_DIR # lono folder - in case code is added later above this that uses cd
bundle install
bundle exec rake install

mkdir -p ~/bin
cat << EOF > ~/bin/lono
#!/bin/bash
# If there's a Gemfile, assume we're in a lono project with a Gemfile for lono
if [ -f Gemfile ]; then
  exec bundle exec $CODEBUILD_SRC_DIR/exe/lono "\$@"
else
  exec $CODEBUILD_SRC_DIR/exe/lono "\$@"
fi
EOF

cat ~/bin/lono

chmod a+x ~/bin/lono
