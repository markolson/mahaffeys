class Beer < ActiveRecord::Base
  validates :name, uniqueness: { scope: :container_type }
end
