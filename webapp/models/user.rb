class User < ActiveRecord::Base
  self.primary_key = :id

  validates :id, uniqueness: true
end
