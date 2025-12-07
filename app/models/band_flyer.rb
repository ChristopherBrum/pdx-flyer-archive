# == Schema Information
#
# Table name: band_flyers
#
#  id         :integer          not null, primary key
#  band_id    :integer          not null
#  flyer_id   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_band_flyers_on_band_id   (band_id)
#  index_band_flyers_on_flyer_id  (flyer_id)
#

class BandFlyer < ApplicationRecord
  belongs_to :band
  belongs_to :flyer
end
