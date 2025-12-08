# == Schema Information
#
# Table name: venues
#
#  id         :integer          not null, primary key
#  name       :string
#  city       :string
#  state      :string
#  country    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Venue < ApplicationRecord
  has_many :flyers

  # Search scope for autocomplete
  scope :search_by_name, ->(query) {
    where("LOWER(name) LIKE ?", "%#{query.to_s.downcase}%").limit(10)
  }
end
