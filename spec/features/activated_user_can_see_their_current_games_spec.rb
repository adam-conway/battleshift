require 'rails_helper'

describe 'Activated User' do
  context 'logs in and navigates to games page' do
    it 'should be able to see their games' do
      user = create(
        :user,
        name: 'Jimmy',
        email: 'nelson.jimmy',
        api_key: '987654321a',
        authenticated: true
      )

      opponent = create(
        :user,
        name: 'Sasha',
        email: 'sasha@gmail.com',
        api_key: '1234',
        authenticated: true
      )

      create(:game, player_1: user)
      create(:game, player_2: user, player_1: opponent)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit dashboard_path

      click_on 'Games'
save_and_open_page
      expect(page).to have_content('Game against Adam (adam.n.conway@gmail.com): Your Turn')
      expect(page).to have_content("Game against Sasha (sasha@gmail.com): Sasha's Turn")
    end
  end
end
