# frozen_string_literal: true

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

  scope :search_by_name, ->(query) {
    where("LOWER(name) LIKE ?", "%#{query.to_s.downcase}%")
      .order(
        Arel.sql("
          CASE
            WHEN LOWER(name) = '#{sanitize_sql_like(query.to_s.downcase)}' THEN 1
            WHEN LOWER(name) LIKE '#{sanitize_sql_like(query.to_s.downcase)}%' THEN 2
            ELSE 3
          END,
          name
        ")
      )
      .limit(10)
  }
end
