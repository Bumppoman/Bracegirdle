class Consumer
  attr_accessor :payload

  def initialize(payload)
    self.payload = payload
  end

  def call
    raise NotImplementedError.new("#{self.class.name}#call is not implemented.")
  end
end