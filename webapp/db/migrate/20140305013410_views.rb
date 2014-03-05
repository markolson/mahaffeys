class Views < ActiveRecord::Migration
  def self.up
    execute <<-SQL1
      create table beer (                                                           
      abv float,                                                                                                                            
      name varchar,
      type varchar,
      id integer);
    SQL1

    execute <<-SQL2
      CREATE VIEW beers AS
      SELECT breweries.brewery_id,
        b.abv,
        b.name,
        b.type,
        b.id
       FROM ( SELECT json_populate_recordset.abv,
                json_populate_recordset.name,
                json_populate_recordset.type,
                json_populate_recordset.id
               FROM json_populate_recordset(NULL::beer, to_json(ARRAY( SELECT json_array_elements(to_json(breweries_1.beers)) AS beer
                       FROM breweries breweries_1))) json_populate_recordset(abv, name, type, id)) b,
        ( SELECT breweries_1.id AS brewery_id,
                json_array_elements(to_json(breweries_1.beers)) AS beer
               FROM breweries breweries_1) breweries
      WHERE (((breweries.beer -> 'id'::text)::text)::integer) = b.id;
    SQL2

    execute <<-SQL
      CREATE VIEW users_beers AS
      SELECT users.id,
      users.name,
      ((unnest(users.beers) -> 'beer_id'::text)::character varying)::integer AS beer_id,
      ((unnest(users.beers) -> 'at'::text)::character varying)::date AS drank_on
     FROM users;
    SQL
  end
 
  def self.down
    execute <<-SQL
      DROP VIEW users_beers;
    SQL
  end
end
