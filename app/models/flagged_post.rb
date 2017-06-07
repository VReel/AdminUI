class FlaggedPost < Post
  attr_reader :flag_data

  def attach_flag_details(flag_data)
    @flag_data = flag_data

    attach_user_details(flag_data['included'])

    self
  end

  def flags
    @flags ||= flag_data['data']
               .map { |flag_data| Flag.new(flag_data) }
               .each { |flag| flag.attach_user_details(flag_data['included']) }
  end
end
