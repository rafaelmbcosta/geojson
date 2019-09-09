require 'rails_helper'

RSpec.describe "Coordinates", type: :request do
  let(:params) do
    {
      "point": {
        "type": "Feature",
        "geometry": {
          "type": "Point",
          "coordinates": [-43.1982421875, -7.406047717076258]
        },
        "properties": {
          "name": "Dinagat Islands"
        }
      }
    }
  end

  describe 'inside' do
    before do
      allow(Coordinate).to receive(:inside_any_polygon?).and_return(true)
    end

    it 'return true if its inside' do
      allow(Coordinate).to receive(:inside).and_return(true)
      post inside_path, params: params.deep_stringify_keys
      expect(response.body).to eq({ inside: true }.to_json)
    end

    it 'return false if its outside' do
      allow(Coordinate).to receive(:inside).and_return(false)
      post inside_path, params: params.deep_stringify_keys
      expect(response.body).to eq({ inside: false }.to_json)
    end

    it 'returns 422 if information is missing' do
      params[:point][:geometry] = {}
      post inside_path, params: params.deep_stringify_keys, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to eq({ error: 'GeoJSON information missing' }.to_json)
    end

    it 'returns 422 if coordinates are invalid' do
      params[:point][:geometry][:coordinates] = [1, 2]
      post inside_path, params: params.deep_stringify_keys, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to eq({ error: 'Invalid coordinate' }.to_json)
    end

    it 'returns 422 if request coordinate is not a point' do
      params[:point][:geometry][:type] = 'Polygon'
      post inside_path, params: params.deep_stringify_keys, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to eq({ error: 'Geojson type is not a Point' }.to_json)
    end
  end
end
