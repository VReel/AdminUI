class Users::SessionsController < Devise::SessionsController
  skip_before_action :only_confirmed, only: :destroy
end
