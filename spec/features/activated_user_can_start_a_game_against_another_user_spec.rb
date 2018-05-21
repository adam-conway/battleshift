require 'rails_helper'

describe 'User' do
  context 'visits games index and wants to start a new game' do
    it 'should be able to start a game against a valid opponent' do
      user = create(
        :user,
        name: 'Jimmy',
        email: 'nelson.jimmy',
        api_key: '987654321a',
        authenticated: true
      )

      opponent = create(:user)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit games_path

      click_on 'Start a New Game'

      select(opponent.email, from 'user[email]')

      click_on 'Attack!'
    end
  end
end
