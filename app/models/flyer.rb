# frozen_string_literal: true

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

  validate :image_presence

  scope :search_by_title, ->(query) {
    where("LOWER(title) LIKE ?", "%#{query.to_s.downcase}%")
      .order(
        Arel.sql("
          CASE
            WHEN LOWER(title) = '#{sanitize_sql_like(query.to_s.downcase)}' THEN 1
            WHEN LOWER(title) LIKE '#{sanitize_sql_like(query.to_s.downcase)}%' THEN 2
            ELSE 3
          END,
          title
        ")
      )
      .limit(10)
  }

  # Assign venue from either ID or name
  def assign_venue_from_params(venue_id, venue_name)
    if venue_id.present?
      self.venue = Venue.find(venue_id)
    elsif venue_name.present?
      self.venue = Venue.find_or_create_by(name: venue_name.strip)
    end
  end

  # Assign bands from JSON data, optionally clearing existing bands
  def assign_bands_from_json(bands_json, clear_existing: false)
    return if bands_json.blank?

    begin
      bands_data = JSON.parse(bands_json)
      self.bands = [] if clear_existing

      bands_data.each do |band_data|
        band = find_or_create_band(band_data)
        next unless band

        # Only add if not already in the collection
        self.bands << band unless self.bands.include?(band)
      end
    rescue JSON::ParserError => e
      Rails.logger.error("Failed to parse bands JSON: #{e.message}")
      errors.add(:bands, "invalid data format")
    end
  end

  private

  def image_presence
    errors.add(:image, "must be attached") unless image.attached?
  end

  def find_or_create_band(band_data)
    if band_data["id"].present?
      Band.find_by(id: band_data["id"])
    elsif band_data["name"].present?
      Band.find_or_create_by(name: band_data["name"].strip)
    end
  end
end
