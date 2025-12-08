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

  has_one_attached :image

  attr_accessor :venue_name

  # Validate that an image is attached
  validate :image_presence

  private

  def image_presence
    errors.add(:image, "must be attached") unless image.attached?
  end
end
