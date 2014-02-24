class CreateBeers < ActiveRecord::Migration
  def change
    create_table :beers do |t|
      t.string :name
      t.integer :container_type
      t.integer :brewery_id
      t.integer :style_id
      t.string :image_url
      t.decimal :abv
    end
  end
end
