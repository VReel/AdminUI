feature 'Visitor confirms email' do
  scenario 'can confirm account while signed in and still be signed in' do
    sign_up_with(Faker::Internet.email, Faker::Internet.password)

    click_confirmation_link(last_email)

    expect(page).to have_content 'You are logged in'
  end

  scenario 'can confirm account while signed out then needs to sign in' do
    sign_up_with(Faker::Internet.email, Faker::Internet.password)
    sign_out

    click_confirmation_link(last_email)

    expect(page).to have_content 'Sign in'
    expect(page).to have_content 'Your email address has been verified'
    expect(User.last.confirmed?).to be true
  end

  scenario 'is already confirmed but clicks confirmation link' do
    user = Fabricate(:user)
    user.confirm
    user.send_confirmation_instructions

    click_confirmation_link(last_email)

    expect(page).to have_content 'Sign in'
  end

  scenario 'is already confirmed and signed in but clicks confirmation link' do
    user = Fabricate(:user)
    user.confirm
    sign_in_with(user)
    user.send_confirmation_instructions

    click_confirmation_link(last_email)

    expect(page).to have_content 'You are logged in'
  end

  scenario 'is already confirmed and signed in but clicks other user confirmation link' do
    user1 = Fabricate(:user)
    user2 = Fabricate(:user)
    user1.confirm
    user2.confirm
    sign_in_with(user1)
    user2.send_confirmation_instructions

    click_confirmation_link(last_email)

    expect(page).to have_content 'Sign in'
  end
end
