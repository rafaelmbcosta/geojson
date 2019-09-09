class GeojsonError
  class OpenCoordinatesError < StandardError
    def message
      'First and last coordinates are not the same'
    end
  end

  class NotPolygonError < StandardError
    def message
      'Geojson type is not a Polygon'
    end
  end

  class NotPointError < StandardError
    def message
      'Geojson type is not a Point'
    end
  end

  class MissingInformationError < StandardError
    def message
      'GeoJSON information missing'
    end
  end

  class NotEnoughCoordinatesError < StandardError
    def message
      'Insuficient coordinates'
    end
  end

  class InvalidCoordinatesError < StandardError
    def message
      'Invalid coordinate'
    end
  end

  class InvalidParametersError < StandardError
    def message
      'Invalid parameters'
    end
  end
end