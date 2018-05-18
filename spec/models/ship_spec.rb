require 'rails_helper'

RSpec.describe Ship, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:length) }
    it { should validate_presence_of(:damage) }
  end

  describe 'relationships' do
    it { should have_many(:spaces) }
  end
end
