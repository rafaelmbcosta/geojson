require 'rails_helper'

RSpec.describe GoogleServiceWorker, type: :worker do
  let(:worker) { GoogleServiceWorker.new }
  let(:data) do
    {
      "results"=> [
        {
          "formatted_address"=>"Caucaia - State of Ceará, Brazil", 
          "geometry"=>{
            "bounds"=>{
              "northeast"=>{"lat"=>-3.5479357, "lng"=>-38.5875831}, 
              "southwest"=>{"lat"=>-3.9923861, "lng"=>-38.9990196}
            }, 
            "location"=>{"lat"=>-3.7203049, "lng"=>-38.6663911}, 
            "location_type"=>"APPROXIMATE", 
            "viewport"=>{
              "northeast"=>{"lat"=>-3.5479357, "lng"=>-38.5875831}, 
              "southwest"=>{"lat"=>-3.9923861, "lng"=>-38.9990196}
            }
          }, 
          "place_id"=>"ChIJOUUtLsywwAcRTZfNRg6BJnw",
          "types"=>["administrative_area_level_2", "political"]
        }
      ], 
      "status"=>"OK"
    }
  end

  describe 'get)data' do
    before do
      allow(Net::HTTP).to receive(:get).and_return({ message: 'success' }.to_json)
    end

    it 'renders the request' do
      expect(worker.get_data(nil)['message']).to eq('success')
    end
  end

  describe 'update_info' do
    let(:coordinate) { Coordinate.create(query: 'fortaleza') }
    let(:feature_collection) { FeatureCollection.new }

    before do
      allow(Coordinate).to receive(:inside_any_polygon?).and_return(true)
    end

    it 'raises Geocoding Error' do
      expect { worker.update_info(coordinate.id, { 'status' => 'Not OK' }) }.to raise_error(GeojsonError::GeocodingError)
    end

    it 'updates coordinate data' do
      expect(worker.update_info(coordinate.id, data.deep_stringify_keys)).to be true
    end
  end
end