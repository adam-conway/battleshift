require 'rails_helper'

describe User, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:password) }
    # Come back to this
    # it { should validate_presence_of(:authenticated) }
  end

  describe 'relationships' do
    it { should have_many(:victories) }
    it { should have_many(:player_1_games) }
    it { should have_many(:player_2_games) }
  end
end
