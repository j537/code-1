class CreateMenuCollectionTables < ActiveRecord::Migration[5.1]
  def change
    # id,name,description,menus_appeared,times_appeared,first_appeared,last_appeared,lowest_price, highest_price
    create_table :dishes do |t|
      t.text :name
      t.text :description
      t.integer :menus_appeared
      t.integer :times_appeared
      t.integer :first_appeared
      t.integer :last_appeared
      t.decimal :lowest_price
      t.decimal :highest_price
    end

    # id,name,sponsor,event,venue,place,physical_description,occasion,notes,call_number,keywords,language,date,location,location_type,currency,currency_symbol,status,page_count,dish_count
    create_table :menus do |t|
      t.text :name
      t.text :sponsor
      t.text :event
      t.text :venue
      t.text :place
      t.text :physical_description
      t.text :occasion
      t.text :notes
      t.text :call_number
      t.date :date
      t.text :location
      t.text :currency
      t.text :currency_symbol, limit: 3

      t.index :place
      t.index :event
      t.index :venue
      t.index :date
    end

    # id,menu_id,page_number,image_id,full_height,full_width,uuid
    create_table :menu_pages do |t|
      t.integer :menu_id, null: false
      t.integer :page_number
      t.integer :full_height
      t.integer :full_width

      t.text :image_id
      t.text :uuid
    end

    # id,menu_page_id,price,high_price,dish_id,created_at,updated_at,xpos,ypos
    create_table :menu_items do |t|
      t.integer :menu_page_id, null: false
      t.integer :dish_id

      t.decimal :price
      t.decimal :high_price

      t.decimal :xpos
      t.decimal :ypos

      t.timestamps
    end
  end
end
