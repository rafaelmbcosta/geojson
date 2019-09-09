require 'rails_helper'

RSpec.describe FeatureCollection, type: :model do
  let(:feature_collection) { FeatureCollection.new }
  let(:geometry) do
    {
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
  end

  let(:areas) do
    {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "properties": {},
          "geometry": geometry
        }
      ]
    }
  end

  describe 'geojson_input' do
    before do
      allow(feature_collection).to receive(:check_geometry).and_return(true)
    end

    it 'return true if geojson is valid' do
      feature_collection.areas = areas
      expect(feature_collection.geojson_input).to be true
    end

    it 'raise  InvalidParametersError if features json is invalid' do
      areas[:extra_parameter] = 'extra!'
      feature_collection.areas = areas
      expect { feature_collection.geojson_input }.to raise_error(GeojsonError::InvalidParametersError)
    end

    it 'raise  InvalidParametersError type is not FeatureCollection' do
      areas[:type] = 'AnotherCollection'
      feature_collection.areas = areas
      expect { feature_collection.geojson_input }.to raise_error(GeojsonError::InvalidParametersError)
    end

    it 'raise  InvalidParametersError if feature is invalid' do
      areas[:features][0]['extra_parameter'] = 'extra!'
      feature_collection.areas = areas
      expect { feature_collection.geojson_input }.to raise_error(GeojsonError::InvalidParametersError)
    end
  end

  describe 'check_geometry' do
    it 'returns true if no exception is raised' do
      expect(feature_collection.check_geometry(geometry.stringify_keys)).to be true
    end

    it 'raises MissingInformationError' do
      geometry['coordinates'] = []
      expect { feature_collection.check_geometry(geometry.stringify_keys) }.to raise_error(GeojsonError::MissingInformationError)
      geometry['coordinates'] = [[]]
      expect { feature_collection.check_geometry(geometry.stringify_keys) }.to raise_error(GeojsonError::MissingInformationError)
    end

    it 'raises InvalidParametersError' do
      geometry['extra'] = 'Extra'
      expect { feature_collection.check_geometry(geometry.stringify_keys) }.to raise_error(GeojsonError::InvalidParametersError)
    end

    it 'raises NotPolygonError' do
      geometry['type'] = 'point'
      expect { feature_collection.check_geometry(geometry.stringify_keys) }.to raise_error(GeojsonError::NotPolygonError)
    end

    it 'raises NotEnoughCoordinatesError' do
      geometry['coordinates'] = [[[1,1],[2,2]]]
      expect { feature_collection.check_geometry(geometry.stringify_keys) }.to raise_error(GeojsonError::NotEnoughCoordinatesError)
    end

    it 'raises InvalidCoordinatesError' do
      geometry['coordinates'] = [[[1, 1], [2, 2], [3, 3]]]
      expect { feature_collection.check_geometry(geometry.stringify_keys) }.to raise_error(GeojsonError::InvalidCoordinatesError)
    end

    it 'raises OpenCoordinatesError' do
      geometry['coordinates'] = [[[1.1, 1.1], [2.2, 2.2], [3.3, 3.3]]]
      expect { feature_collection.check_geometry(geometry.stringify_keys) }.to raise_error(GeojsonError::OpenCoordinatesError)
    end
  end

  describe 'location_array' do
    before do
      feature_collection.areas = areas.stringify_keys
    end

    let(:expectation) do
      [
        [
          [-40.869140625, -3.337953961416472],
          [-40.78125, -9.535748998133615],
          [-31.904296874999996, -9.015302333420586],
          [-31.904296874999996, -9.015302333420586],
          [-32.16796875, -2.460181181020993], 
          [-40.869140625, -3.337953961416472]
        ]
      ]
    end

    it 'return an array of a arrays' do
      expect(feature_collection.location_array).to eq(expectation)
    end
  end
end
