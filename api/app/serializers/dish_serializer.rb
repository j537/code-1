class DishSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :description,
             :menus_appeared,
             :times_appeared,
             :lowest_price,
             :highest_price

end
