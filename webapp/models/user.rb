require 'date'
class User < ActiveRecord::Base
  self.primary_key = :id

  validates :id, uniqueness: true

  def beers
    b = ["SELECT beer_id FROM users_beers WHERE id = ?"] + [self.id]
    sql = ActiveRecord::Base.send(:sanitize_sql_array, b)
    @beers ||= Beer.find_by_sql(sql).map{|x| x['beer_id'] }
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
end
