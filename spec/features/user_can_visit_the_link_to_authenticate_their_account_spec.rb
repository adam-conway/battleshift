require 'rails_helper'

describe 'User has received the email' do
  context 'visits the link' do
    it 'should make them authenticated' do
      user = create(:user)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      expect(user.authenticated).to eq(false)

      visit authenticate_path(user: user.id)

      expect(page).to have_content('Thank you for authenticating your account!')

      expect(current_path).to eq(dashboard_path)
    end
  end
end
