feature 'Visitor signs up' do
  scenario 'can sign up' do
    sign_up_with(Faker::Internet.email, Faker::Internet.password)
    expect(page).to have_content 'Please verify your email address'
  end

  scenario 'receives confirmation email' do
    email = Faker::Internet.email
    sign_up_with(email, Faker::Internet.password)
    expect(last_email.to.first).to eq email
  end
end
