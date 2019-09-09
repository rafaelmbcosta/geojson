require 'rails_helper'

RSpec.describe "FeatureCollections", type: :request do
  let(:new_area) do
    {
      "feature_collection": {
          "type": "FeatureCollection",
          "features": [
            {
              "type": "Feature",
              "properties": {},
              "geometry": {
                "type": "Polygon",
                "coordinates": [
                  [
                    [
                      -40.869140625,
                      -3.337953961416472
                    ],
                    [
                      -40.78125,
                      -9.535748998133615
                    ],
                    [
                      -31.904296874999996,
                      -9.015302333420586
                    ],
                    [
                      -32.16796875,
                      -2.460181181020993
                    ],
                    [
                      -40.869140625,
                      -3.337953961416472
                    ]
                  ]
                ]
              }
            }
          ]
        }
     }
  end

  let(:missing_area) { { "type": "FeatureCollection" } }

  describe 'create' do
    let(:invalid_coordinates) { [[[1, 1], [2, 2], [3, 3], [1, 1]]] }
    let(:insuficient_coordinates) { [[[1, 1], [2, 2]]] }
    let(:open_coordinates) { [[[1.1, 1.1], [2.2, 2.2], [3.3, 3.3]]] }

    it 'returns 201 in success' do
      post '/feature_collections', params: new_area, as: :json
      expect(response).to have_http_status(:created)
      expect(response.body).to eq({ message: 'Polygon created' }.to_json)
    end

    it 'returns 422 if request contains invalid parameters' do
      new_area[:feature_collection][:extra_invalid_parameter] = 'Invalid parameter'
      post '/feature_collections', params: new_area, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to eq({ error: 'Invalid parameters' }.to_json)
    end

    it 'returns 422 if request misses information' do
      new_area[:feature_collection][:features].first[:geometry] = {}
      post '/feature_collections', params: new_area, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to eq({ error: 'GeoJSON information missing' }.to_json)
    end

    it 'returns 422 if request contains invalid coordinates' do
      new_area[:feature_collection][:features].first[:geometry][:coordinates] = invalid_coordinates
      post '/feature_collections', params: new_area, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to eq({ error: 'Invalid coordinate' }.to_json)
    end

    it 'returns 422 if request contains insuficient coordinates' do
      new_area[:feature_collection][:features].first[:geometry][:coordinates] = insuficient_coordinates
      post '/feature_collections', params: new_area, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to eq({ error: 'Insuficient coordinates' }.to_json)
    end

    it 'returns 422 if request coordinate is not a polygon' do
      new_area[:feature_collection][:features].first[:geometry][:type] = 'Point'
      post '/feature_collections',params: new_area, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to eq({ error: 'Geojson type is not a Polygon' }.to_json)
    end

    it 'returns 422 if request coordinates are not closed' do
      new_area[:feature_collection][:features].first[:geometry][:coordinates] = open_coordinates
      post '/feature_collections', params: new_area, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to eq({ error: 'First and last coordinates are not the same' }.to_json)
    end
  end

  describe 'areas' do
    let(:feature_collection) { FeatureCollection.create(areas: new_area[:feature_collection].stringify_keys)}

    before do
      allow(FeatureCollection).to receive(:last).and_return(feature_collection)
    end

    it 'returns the last created collection' do
      get '/areas'
      expect(response).to  have_http_status(:ok)
      expect(response.body).to eq(new_area[:feature_collection].to_json)
    end
  end

  describe 'show' do
    let(:feature_collection) { FeatureCollection.create(areas: new_area[:feature_collection])}

    it 'returns the feature with the ID' do
      get "/feature_collections/#{feature_collection.id}"
      expect(response).to  have_http_status(:ok)
      expect(response.body).to eq(feature_collection.to_json)
    end

    it 'returns record not found' do
      get "/feature_collections/-1"
      expect(response).to  have_http_status(:unprocessable_entity)
      expect(response.body).to eq({ error: 'Not found' }.to_json)
    end
  end
end
