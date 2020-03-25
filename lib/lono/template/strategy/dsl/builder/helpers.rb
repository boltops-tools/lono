# Built-in helpers for the DSL form
class Lono::Template::Strategy::Dsl::Builder
  module Helpers
    extend Memoist
    include CoreHelper
    include Ec2Helper
    include FileHelper
    include LookupHelper
    include S3Helper
    include TagsHelper

    include Lono::Template::Strategy::Common::Helpers
  end
end
