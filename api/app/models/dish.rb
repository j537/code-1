class Dish < ApplicationRecord
  has_many :menu_items
  has_many :menu_pages
  has_and_belongs_to_many :menu_pages, join_table: 'menu_items'
  has_many :menus, through: :menu_pages

  validates :name, presence: true
end
