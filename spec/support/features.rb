require_relative 'features/session_helpers'
require_relative 'features/email_helpers'

RSpec.configure do |config|
  config.include Features::SessionHelpers, type: :feature
  config.include Features::EmailHelpers, type: :feature
end
