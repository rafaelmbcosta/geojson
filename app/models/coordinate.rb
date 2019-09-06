class Coordinate < ApplicationRecord

  include Concerns::Polygon
  
  def self.base
    JSON.parse(File.read("#{Rails.root}/lib/areas.json"))
  end

  def self.base_points
    base
  end
end
