class RaiseError < StandardError
  def initialize(msg = "Invalid ship placement")
    super
  end
end
