feature 'Visitor signs in' do
  scenario 'when unconfirmed' do
    user = Fabricate(:user)
    sign_in_with(user)
    expect(page).to have_content 'Please verify your email address'
  end

  scenario 'when confirmed' do
    user = Fabricate(:user)
    user.confirm
    sign_in_with(user)
    expect(page).to have_content 'You are logged in'
  end
end
