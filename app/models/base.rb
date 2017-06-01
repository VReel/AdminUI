class Base
  attr_reader :data

  def initialize(data)
    @data = data
  end

  # Automagically create methods on the attributes packet.
  def method_missing(method_id, *arguments, &block)
    return data['attributes'][method_id.to_s] if data['attributes'][method_id.to_s].present? && arguments.none? && block.nil?

    super
  end
end
