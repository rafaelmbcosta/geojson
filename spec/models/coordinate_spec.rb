require 'rails_helper'

RSpec.describe Coordinate, type: :model do
  it_behaves_like 'polygon'

  describe 'base' do
    it 'must be a hash' do
      expect(Coordinate.base).to be_a(Hash)
    end

    it 'must contain a type FeatureCollection' do
      expect(Coordinate.base['type']).to eq('FeatureCollection')
    end
  end
end
