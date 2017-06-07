class Base
  attr_reader :data
  attr_reader :user

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
    included_data ||= []

    included_data.each do |item|
      @user = item if item['id'] == user_id
    end
    self
  end

  def created_at
    return unless data['attributes']['created_at'].present?

    Time.zone.parse(data['attributes']['created_at'])
  end

  # Automagically create methods on the attributes packet.
  def method_missing(method_id, *arguments, &block)
    return data['attributes'][method_id.to_s] if data['attributes'].key?(method_id.to_s) && arguments.none? && block.nil?

    super
  end
end
