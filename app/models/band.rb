class Band < ApplicationRecord
  has_many :band_flyers, dependent: :destroy
  has_many :flyers, through: :band_flyers
end
