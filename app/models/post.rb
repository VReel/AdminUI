class Post < Base
  def hash_tags
    return [] if caption.blank?

    caption.scan(/#([a-z0-9\w]+\b)/i).flatten.map(&:downcase)
  end
end
