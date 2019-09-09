require "rails_helper"

RSpec.describe FeatureCollectionsController, type: :routing do
  describe "routing" do
    it "routes to 'areas'" do
      expect(get: '/areas').to route_to('feature_collections#areas')
    end

    it "routes to 'create'" do
      expect(post: 'feature_collections').to route_to('feature_collections#create')
    end
  end
end
