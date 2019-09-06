module Concerns
  module Polygon
    extend ActiveSupport::Concern

    included do
      # Calculates if point is included in polygon
      # Is a class method because its used with the static values
      def self.base_coordinate_array
         base['features'].collect { |f| f['geometry']['coordinates'].first }
      end

      # Iterate through all polygons check if its inside any
      def self.inside_any_polygon?(x, y)
        base_coordinate_array.each do |coordinates|
          return true if inside_polygon?(coordinates, x, y)
        end
        false
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