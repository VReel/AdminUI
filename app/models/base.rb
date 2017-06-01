class Base
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def id
    data['id']
  end

  def user_id
    data['relationships']['user']['data']['id']
  end

  def user_handle
    user['attributes']['handle']
  end

  def attach_user_details(included_data)
    included_data.each do |item|
      @user = item if item['id'] == user_id
    end
    self
  end

  # Automagically create methods on the attributes packet.
  def method_missing(method_id, *arguments, &block)
    return data['attributes'][method_id.to_s] if data['attributes'][method_id.to_s].present? && arguments.none? && block.nil?

    super
  end
end
