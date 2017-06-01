class FlaggedPost < Base
  attr_reader :flag_data
  attr_reader :user

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

  def attach_flag_details(flag_data)
    @flag_data = flag_data
    self
  end

  def flags
    @flags ||= flag_data['data']
               .map { |flag_data| Flag.new(flag_data) }
               .each { |flag| flag.attach_user_details(flag_data['included']) }
  end
end
