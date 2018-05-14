require 'rails_helper'

describe 'User' do
  context 'Receives registration email' do
    scenario 'and can click the link' do
      user = User.create(name: 'Jimmy', email: 'nelson.jimmy@gmail.com', password: 'password', password_confirmation: 'password')
      user.update(api_key: SecureRandom.urlsafe_base64)

      UserMailer.with(user: user).registration_email.deliver_now

      email = ActionMailer::Base.deliveries.last

      expect(email.from).to eq(['no-reply@battleshift.com'])
      expect(email.to).to eq([user.email])
      expect(email.subject).to eq('Welcome to Battleshift!')
      expect(email.html_part.body.to_s).to have_content('Visit here to activate your account.')
      expect(email.html_part.body.to_s).to have_content('Visit here to activate your account.')
      expect(email.text_part.body.to_s).to have_content("Your API key: #{user.api_key}")
      expect(email.html_part.body.to_s).to have_content("Your API key: #{user.api_key}")
    end
  end
end
