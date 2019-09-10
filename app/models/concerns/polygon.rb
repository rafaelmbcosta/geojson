require 'geojson_error'

module Concerns
  module Polygon
    extend ActiveSupport::Concern

    included do
      def self.inside(params)
        raise GeojsonError::MissingInformationError if params.keys.sort != %w[geometry properties type]

        raise GeojsonError::MissingInformationError if params['geometry'].blank? ||
                                                       params['geometry']['coordinates'].blank?
        raise GeojsonError::InvalidCoordinatesError unless float_coordinates?(params['geometry']['coordinates'])

        raise GeojsonError::NotPointError if params['geometry']['type'] != 'Point'

        coordinates = params['geometry']['coordinates']
        inside_any_polygon?(coordinates[0], coordinates[1])
      end

      # Calculates if point is included in polygon
      # Is a class method because its used with the static values
      def self.inside_any_polygon?(x, y)
        FeatureCollection.last.location_array.each do |coordinates|
          return true if inside_polygon?(coordinates, x, y)
        end
        false
      end

      def inside_any_polygon?
        self.class.inside_any_polygon?(x, y)
      end

      # Verifies if the coordinates are inside the polygon
      # Code adapted from the geokit gem
      # no need to check if polygon is closed because its static and closed.
      def self.inside_polygon?(coordinates, x, y)
        last_point = coordinates.last
        oddNodes = false
        coordinates.each do |coordinate|
          yi = coordinate[1]
          xi = coordinate[0]
          yj = last_point[1]
          xj = last_point[0]
          if yi < y && yj >= y ||
              yj < y && yi >= y
            oddNodes = !oddNodes if xi + (y - yi) / (yj - yi) * (xj - xi) < x
          end
          last_point = coordinate
        end
        oddNodes
      end
    end
  end
end