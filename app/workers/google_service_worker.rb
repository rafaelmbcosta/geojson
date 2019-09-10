require 'net/http'
require 'open-uri'
require 'geojson_error'

class GoogleServiceWorker
  include Sidekiq::Worker
  sidekiq_options retry:false

  URL = 'https://maps.googleapis.com/maps/api/geocode/json?'.freeze

  def get_data(uri)
    request = Net::HTTP.get(uri)
    JSON.parse(request)
  end

  def update_info(id, data)
    raise GeojsonError::GeocodingError if data['status'] != 'OK'

    coordinate = Coordinate.find(id)
    location = data['results'].first['geometry']['location']
    coordinate.name = data['results'].first['formatted_address']
    coordinate.x = location['lat']
    coordinate.y = location['lng']
    coordinate.inside_polygon = coordinate.inside_any_polygon?
    coordinate.save
  end

  def perform(id, query)
    uri = URI("#{URL}address=#{query}&key=#{ENV['google_api_key']}")
    data = get_data(uri)
    update_info(id, data)
  rescue GeojsonError::GeocodingError, StandardError => e
    coordinate = Coordinate.find(id)
    coordinate.update_attributes(async_errors: e.message)
  end 
end