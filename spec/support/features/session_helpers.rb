module Features
  module SessionHelpers
    def sign_up_with(email, password)
      visit new_user_registration_path
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      fill_in 'Confirm Password', with: password
      click_button 'Sign up'
    end

    def sign_in_with(user)
      visit '/'
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Sign in'
    end

    def sign_out
      visit '/users/sign_out'
    end
  end
end
