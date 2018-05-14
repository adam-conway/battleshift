require 'rails_helper'

describe 'API Key' do
  describe 'creation' do
    it 'can be created' do
      key = ApiKey.generator
      expect(key).to be_a String
    end
  end
end
