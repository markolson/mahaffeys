require 'date'
class User < ActiveRecord::Base
  self.primary_key = :id

  validates :id, uniqueness: true

  def add_beer(beer)
  		blob = {"at" => Date.today.to_s, "beer_id" => beer.id}.to_json
  	  b = ["UPDATE users SET beers = beers || ?::json WHERE id=?"] + [blob, id]
    	sql = ActiveRecord::Base.send(:sanitize_sql_array, b)
    	ActiveRecord::Base.connection.execute(sql)
  end

  def drank?(beer)
  	beer_id = beer.id
  	begin
  		b = ["SELECT 1 FROM users_beers WHERE beer_id = ? AND id = ?"] + [beer_id, self.id]
  		p b
    	sql = ActiveRecord::Base.send(:sanitize_sql_array, b)
    	p sql
    	return Beer.find_by_sql(sql).count >= 1
    	exit
  	rescue
  		p $!
  		return false
  	end
  end
end
