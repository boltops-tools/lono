class Lono::Cfn::Plan::Changeset
  class Tags < Base
    def changes
      old = simplify(stack.tags)
      new = simplify(@change_set.tags)
      diff = Lono::Cfn::Plan::Diff::Data.new(old, new)
      diff.show("Tag Changes:")
    end

    def simplify(tags)
      tags.inject({}) do |result, i|
        result.merge(i.key => i.value)
      end
    end
  end
end
