class User < ActiveRecord::Base
  set_primary_key :id

  validates :id, uniqueness: true
end
