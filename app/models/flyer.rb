class Flyer < ApplicationRecord
  belongs_to :venue
  has_many :band_flyers, dependent: :destroy
  has_many :bands, through: :band_flyers
end
