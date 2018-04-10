class Location < ApplicationRecord
  belongs_to :sensor
  validates :street,presence: true
  validates :zip,presence: true
  validates :longitude,presence: true
  validates :latitude,presence: true
  validates :altitude,presence: true
  validates :direction,presence: true
end