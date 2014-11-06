class Flash
  attr_reader :messages

  def initialize
    @now = false
    @messages = {}
  end

  def [](key)
    message = @messages["#{key}"]
    p @messages
    @messages["#{key}"] = nil
    p @messages
    message
  end

  def []=(key, val)
    @messages["#{key}"] = val
  end
end
