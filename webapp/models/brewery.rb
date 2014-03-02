class Brewery < ActiveRecord::Base
  validates :name, uniqueness: true
end
