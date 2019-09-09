require "rails_helper"

RSpec.describe CoordinatesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(post: '/inside').to route_to('coordinates#inside')
    end
  end
end
