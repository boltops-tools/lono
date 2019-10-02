# Unsure why but zeitwerk is not autovifiying this as a module
# Adding this fixes the issue.
# Also using bundle exec in front works. Ran into this with jets also and Jets just bundle exec witihin the project.
module Lono::AppFile
end