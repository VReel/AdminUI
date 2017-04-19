class FlaggedPost
  attr_reader :data
  attr_reader :user

  def initialize(data)
    @data = data
  end

  def user_id
    data['relationships']['user']['data']['id']
  end

  def attach_user_details(included_data)
    included_data.each do |item|
      @user = item if item['id'] == user_id
    end
  end
end
