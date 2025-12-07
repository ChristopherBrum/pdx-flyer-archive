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
end
