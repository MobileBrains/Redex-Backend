# == Schema Information
#
# Table name: courriers_locations
#
#  id            :integer          not null, primary key
#  latitude      :float
#  longitude     :float
#  user_id       :integer
#  location_type :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  location      :string
#

class CourriersLocation < ApplicationRecord

  reverse_geocoded_by :latitude, :longitude, :address => :location
  after_validation :reverse_geocode, if: -> {self.longitude.present? and self.latitude.present? and self.longitude_changed? or self.latitude_changed?  }   # auto-fetch address

  enum location_type: { Requested: 0,
                        Automatic: 1
              }
end
