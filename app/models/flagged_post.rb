class FlaggedPost
  attr_reader :data
  attr_reader :user
  attr_reader :flag_data

  def initialize(data)
    @data = data
  end

  def id
    data['id']
  end

  def user_id
    data['relationships']['user']['data']['id']
  end

  def thumbnail_url
    data['attributes']['thumbnail_url']
  end

  def original_url
    data['attributes']['original_url']
  end

  def caption
    data['attributes']['caption']
  end

  def created_at
    data['attributes']['created_at']
  end

  def edited
    data['attributes']['edited']
  end

  def like_count
    data['attributes']['like_count']
  end

  def flag_count
    data['attributes']['flag_count']
  end

  def comment_count
    data['attributes']['comment_count']
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
    @flags ||= flag_data['data'].map { |flag_data| Flag.new(flag_data) }.each { |flag| flag.attach_user_details(flag_data['included']) }
  end
end
