class User < Base
  def confirmed_at
    return 'Never' unless data['attributes']['confirmed_at'].present?

    Time.zone.parse(data['attributes']['confirmed_at'])
  end

  def confirmed?
    data['attributes']['confirmed_at'].present?
  end
end
