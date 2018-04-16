# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180414014645) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dishes", force: :cascade do |t|
    t.text "name"
    t.text "description"
    t.integer "menus_appeared"
    t.integer "times_appeared"
    t.integer "first_appeared"
    t.integer "last_appeared"
    t.decimal "lowest_price"
    t.decimal "highest_price"
  end

  create_table "menu_items", force: :cascade do |t|
    t.integer "menu_page_id", null: false
    t.integer "dish_id"
    t.decimal "price"
    t.decimal "high_price"
    t.decimal "xpos"
    t.decimal "ypos"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "menu_pages", force: :cascade do |t|
    t.integer "menu_id", null: false
    t.integer "page_number"
    t.integer "full_height"
    t.integer "full_width"
    t.text "image_id"
    t.text "uuid"
  end

  create_table "menus", force: :cascade do |t|
    t.text "name"
    t.text "sponsor"
    t.text "event"
    t.text "venue"
    t.text "place"
    t.text "physical_description"
    t.text "occasion"
    t.text "notes"
    t.text "call_number"
    t.date "date"
    t.text "location"
    t.text "currency"
    t.text "currency_symbol"
    t.index ["date"], name: "index_menus_on_date"
    t.index ["event"], name: "index_menus_on_event"
    t.index ["place"], name: "index_menus_on_place"
    t.index ["venue"], name: "index_menus_on_venue"
  end

end
