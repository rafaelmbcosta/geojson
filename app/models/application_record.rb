class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # Check if all coordinates are float
  def self.float_coordinates?(coordinates)
    (coordinates.flatten.collect(&:class) - [Float]) == []
  end

  # when is called from instance
  def float_coordinates?(coordinates)
    self.class.float_coordinates?(coordinates)
  end
end
