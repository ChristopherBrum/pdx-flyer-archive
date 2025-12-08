# == Schema Information
#
# Table name: bands
#
#  id         :integer          not null, primary key
#  name       :string
#  website    :string
#  city       :string
#  state      :string
#  country    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Band < ApplicationRecord
  has_many :band_flyers, dependent: :destroy
  has_many :flyers, through: :band_flyers

  # Search scope for autocomplete
  scope :search_by_name, ->(query) {
    where("LOWER(name) LIKE ?", "%#{query.to_s.downcase}%").limit(10)
  }
end
