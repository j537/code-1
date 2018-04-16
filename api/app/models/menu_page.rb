class MenuPage < ApplicationRecord
  belongs_to :menu
  has_many :menu_items
  has_many :dishes, through: :menu_items
  has_and_belongs_to_many :dishes

  REQUIRED_HEADERS = %i[id menu_id].freeze
end