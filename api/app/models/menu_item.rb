class MenuItem < ApplicationRecord
  belongs_to :menu_page
  belongs_to :dish

  REQUIRED_HEADERS = %i[id menu_page_id dish_id].freeze
end
