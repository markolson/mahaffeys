class CreateBreweries < ActiveRecord::Migration
  def change
    create_table :breweries do |t|
      t.string :name
      t.json :beers, array: true
    end
    Brewery.create(name: "Default")
  end
end
