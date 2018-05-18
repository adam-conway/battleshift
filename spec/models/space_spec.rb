require 'rails_helper'

RSpec.describe Space, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:status) }
  end

  describe 'relationships' do
    it { should belong_to(:board) }
    it { should belong_to(:ship) }
  end
end
