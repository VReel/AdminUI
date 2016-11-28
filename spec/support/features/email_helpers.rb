module Features
  module EmailHelpers
    def last_email
      ActionMailer::Base.deliveries.last
    end

    def click_confirmation_link(email)
      ctoken = email.body.match(/confirmation_token=[^\"]*/)
      visit "/users/confirmation?#{ctoken}"
    end
  end
end
