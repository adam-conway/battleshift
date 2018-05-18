require 'rails_helper'

RSpec.describe Game, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:player_1_turns) }
    it { should validate_presence_of(:player_2_turns) }
    it { should validate_presence_of(:current_turn) }
  end

  describe 'relationships' do
    it { should belong_to(:player_1) }
    it { should belong_to(:player_2) }
    it { should belong_to(:player_1_board) }
    it { should belong_to(:player_2_board) }
    it { should belong_to(:winner) }
  end
end
