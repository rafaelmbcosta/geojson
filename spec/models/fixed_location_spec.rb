require 'rails_helper'

RSpec.describe FixedLocation, type: :model do
  describe 'base' do
    it 'must be a hash' do
      expect(FixedLocation.base).to be_a(Hash)
    end

    it 'must contain a type FeatureCollection' do
      expect(FixedLocation.base['type']).to eq('FeatureCollection')
    end
  end
end
