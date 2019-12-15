module Lono::Template::Strategy::Dsl::Builder::Section
  module Extensions
    def parameter_group(label)
      @group_label = label
      yield
      @group_label = nil
    end
  end
end
