class Flag < Base
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
    included_data.each do |item|
      @user = item if item['id'] == user_id
    end
    self
  end
end
