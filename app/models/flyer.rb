# == Schema Information
#
# Table name: flyers
#
#  id         :integer          not null, primary key
#  title      :string
#  event_date :date
#  venue_id   :integer          not null
#  notes      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_flyers_on_venue_id  (venue_id)
#

class Flyer < ApplicationRecord
  belongs_to :venue
  has_many :band_flyers, dependent: :destroy
  has_many :bands, through: :band_flyers
end
