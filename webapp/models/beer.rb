class Beer < ActiveRecord::Base
  validates :name, uniqueness: { scope: :type }
  
  self.inheritance_column = 'inheritance_column'
  
  def self.create_in_brewery(id, blob)
  	b = ["UPDATE breweries SET beers = beers || ?::json WHERE id=?"] + [blob.to_json, id]
    sql = ActiveRecord::Base.send(:sanitize_sql_array, b)
    ActiveRecord::Base.connection.execute(sql)
    return Beer.where(:name => blob['name']).where(:type => blob['type']).first
  end

  def self.next_id
  	(Beer.maximum('id') || 0) + 1
  end

  def as_json(record)
    {name: name, id: id}
  end
end
