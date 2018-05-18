require 'rails_helper'

RSpec.describe Board, type: :model do
  describe 'relationships' do
    it { should have_one(:player_1_board) }
    it { should have_one(:player_2_board) }
    it { should have_many(:spaces) }
  end
end
