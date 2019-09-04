class FixedLocation < ApplicationRecord
  def self.base
    JSON.parse(File.read("#{Rails.root}/lib/areas.json"))
  end
end
