require 'geojson_error'

class FeatureCollection < ApplicationRecord

  validate :geojson_input

  KEYS = %w[features type].freeze
  FEATURE_KEYS = %w[geometry properties type].freeze
  GEOMETRY_KEYS = %w[coordinates type].freeze


  # Validates if the json keys are present and doesnt contain extras
  # The reason for this is because I can't get array of arrays in rails strong parameters
  # Also don't want to iterate many times through the json
  def geojson_input
    raise GeojsonError::InvalidParametersError if areas.keys.sort != KEYS

    raise GeojsonError::InvalidParametersError if areas['type'] != 'FeatureCollection'

    areas['features'].each do |feature|
      raise GeojsonError::InvalidParametersError if feature.keys.sort != FEATURE_KEYS

      check_geometry(feature['geometry'])
    end
    true
  end

  def check_geometry(geometry)
    if geometry.blank? || geometry['coordinates'].blank? || geometry['coordinates'][0].blank?
      raise GeojsonError::MissingInformationError
    end
    coordinates = geometry['coordinates'][0]
    raise GeojsonError::InvalidParametersError if geometry.keys.sort != GEOMETRY_KEYS

    raise GeojsonError::NotPolygonError if geometry['type'] != 'Polygon'

    raise GeojsonError::NotEnoughCoordinatesError if coordinates.size < 3

    raise GeojsonError::InvalidCoordinatesError unless float_coordinates?(coordinates)

    raise GeojsonError::OpenCoordinatesError unless coordinates.first == coordinates.last

    true
  end

  # collects the arrays of coordinates
  def location_array
    areas['features'].collect { |f| f['geometry']['coordinates'].first }
  end
end
