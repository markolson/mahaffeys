require 'date'
class User < ActiveRecord::Base
  self.primary_key = :id

  validates :id, uniqueness: true

  def beer_ids
    (beers || {}).map{|b| b['beer_id'] }
  end
  
  def add_beer(beer)
    blob = {"at" => Date.today.to_s, "beer_id" => beer.id}.to_json
    b = ["UPDATE users SET beers = beers || ?::json WHERE id=?"] + [blob, id]
    sql = ActiveRecord::Base.send(:sanitize_sql_array, b)
    ActiveRecord::Base.connection.execute(sql)
  end

  def drank?(beer)
    return beers.include?(beer.id)
  end

  def as_json(record)
    {name: name, id: id, beers: beer_ids }
  end
end
