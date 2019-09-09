require 'rails_helper'

shared_examples 'polygon' do
  let(:model) { described_class }
  let(:feature_collection) { FeatureCollection.new }
  let(:coordinates) do
    [   
      [-119.61914062499999, 33.578014746143985], [-113.37890625, 30.90222470517144],
      [-105.99609375, 31.12819929911196], [-105.29296874999999, 32.99023555965106],
      [-105.8203125, 35.02999636902566], [-106.962890625, 35.31736632923788],
      [-108.544921875, 35.53222622770337], [-114.08203125, 35.38904996691167],
      [-118.564453125, 38.13455657705411], [-120.58593749999999, 42.293564192170095],
      [-120.41015624999999, 45.089035564831036], [-118.47656249999999, 46.619261036171515],
      [-116.01562499999999, 47.040182144806664], [-110.478515625, 46.98025235521883],
      [-107.841796875, 44.902577996288876], [-105.99609375, 40.78054143186033],
      [-104.94140625, 36.80928470205937], [-103.798828125, 33.87041555094183],
      [-100.986328125, 34.08906131584994], [-100.283203125, 39.095962936305476],
      [-101.42578124999999, 45.336701909968134], [-106.435546875, 50.233151832472245],
      [-117.861328125, 50.233151832472245], [-123.74999999999999, 46.558860303117164],
      [-124.01367187499999, 39.027718840211605], [-119.61914062499999, 33.578014746143985]
    ]
  end

  before do
    allow(FeatureCollection).to receive(:last).and_return(feature_collection)
    allow(feature_collection).to receive(:location_array).and_return(coordinates)
  end

  describe 'inside_polygon?' do
    it 'returns true if its inside' do
      expect(model.inside_polygon?(coordinates, -121.640625, 40.44694705960048)).to be true
      expect(model.inside_polygon?(coordinates, -112.8515625, 34.88593094075317)).to be true
      expect(model.inside_polygon?(coordinates, -111.4453125, 49.61070993807422)).to be true
      expect(model.inside_polygon?(coordinates, -105.46875, 46.558860303117164)).to be true
      expect(model.inside_polygon?(coordinates, -104.0625, 42.032974332441405)).to be true
    end

    it 'returns false if its not inside' do
      expect(model.inside_polygon?(coordinates, -133.2421875, 39.36827914916014)).to be false
      expect(model.inside_polygon?(coordinates, -114.2578125, 53.54030739150022)).to be false
      expect(model.inside_polygon?(coordinates, -113.203125, 42.5530802889558)).to be false
      expect(model.inside_polygon?(coordinates, -92.8125, 40.17887331434696)).to be false
      expect(model.inside_polygon?(coordinates, -104.94140625, 34.45221847282654)).to be false
    end
  end

  describe 'inside_any_polygon?' do
    it 'return true if any inside_polygon returns true' do
      allow(model).to receive(:inside_polygon?).and_return(true)
      expect(model.inside_any_polygon?(-92.8125, 40.17887331434696)).to be true
    end

    it 'return false if any inside_polygon returns false' do
      allow(model).to receive(:inside_polygon?).and_return(false)
      expect(model.inside_any_polygon?(-92.8125, 40.17887331434696)).to be false
    end
  end

  describe 'inside' do
    let(:params) do
      {
        "type": "Feature",
        "geometry": {
          "type": "Point",
          "coordinates": [-43.1982421875, -7.406047717076258]
        },
        "properties": {
          "name": "Dinagat Islands"
        }
      }
    end

    before do
      allow(model).to receive(:inside_any_polygon?).and_return(true)
    end

    it 'return true if no exception is caught' do
      expect(model.inside(params.deep_stringify_keys)).to be true
    end

    it 'raises NotPointError' do
      params[:geometry][:type] = 'Polygon'
      expect { model.inside(params.deep_stringify_keys) }.to raise_error(GeojsonError::NotPointError)
    end

    it 'raises InvalidCoordinatesError' do
      params[:geometry][:coordinates] = [1, 2]
      expect { model.inside(params.deep_stringify_keys) }.to raise_error(GeojsonError::InvalidCoordinatesError)
    end

    it 'raises MissingInformationError' do
      params['geometry'] = {}
      expect { model.inside(params.deep_stringify_keys) }.to raise_error(GeojsonError::MissingInformationError)
    end
  end
end