class Flash
  attr_reader :messages

  def initialize
    @messages = {}
  end

  def [](key)
    @messages["#{key}"]
  end

  def []=(key, val)
    @messages["#{key}"] = val
  end
end
