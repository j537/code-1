if ENV['ALLOW_SEED'] == 'true'
  MenuItem.delete_all
  MenuPage.delete_all
  Menu.delete_all
  Dish.delete_all

  50.times do |i|
    Dish.create name: "Dish #{i}",
                description: "Description #{i}"

  end

  5.times do |i|
    menu = Menu.create name: "Menu #{i}",
                sponsor: "Sponsor #{i}",
                event: "Event #{i}",
                venue: "Venue #{i}",
                place: "Place #{i}",
                physical_description: "Description #{i}",
                occasion: "Occasion #{i}",
                notes: "Notes #{i}",
                call_number: "0413111111",
                date: Time.zone.today,
                location: "Location #{i}",
                currency: 'AUD',
                currency_symbol: '$'

    5.times do |j|
      page = menu.menu_pages.create page_number: j, full_height: 500, full_width: 300
      8.times do |n|
        page.menu_items.create dish_id: Dish.ids.sample, price: n+10, high_price: n+15
      end
    end
  end
end
