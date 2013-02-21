class Hash
  alias hkeys keys

  def keys
    hkeys.sort {|a,b| a.to_s <=> b.to_s }
  end

  def each
    keys.each { |k| yield k, self[k] }
  end
end