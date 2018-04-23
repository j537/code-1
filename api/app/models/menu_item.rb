class MenuItem < ApplicationRecord
  belongs_to :menu_page
  belongs_to :dish

  REQUIRED_HEADERS = %i[id menu_page_id dish_id].freeze

  after_destroy :update_dish_counters
  after_save :update_dish_counters

  def update_dish_counters
    dish.menus_appeared = dish.menus.count
    dish.times_appeared = dish.menu_items.count
    dish.lowest_price = dish.menu_items.minimum(:price)
    dish.highest_price = dish.menu_items.maximum(:price)
    dish.save
  end
end
