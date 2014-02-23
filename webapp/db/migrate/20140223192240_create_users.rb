class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: false do |t|
      t.integer :id, null: false
      t.string :name
      t.integer :beer_count
      t.timestamp :last_scraped
    end

    execute "ALTER TABLE users ADD PRIMARY KEY (id);"
  end
end
