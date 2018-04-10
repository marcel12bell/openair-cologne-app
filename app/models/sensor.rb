class Sensor < ApplicationRecord
  belongs_to :user, optional: true
  has_many :locations
end