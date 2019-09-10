class Coordinate < ApplicationRecord
  include Concerns::Polygon
  
  validate :parameters

  after_create :get_details

  def parameters
    raise GeojsonError::InvalidParametersError if query.blank?
  end

  def get_details
    GoogleServiceWorker.perform_async(id, query)
  end
end
