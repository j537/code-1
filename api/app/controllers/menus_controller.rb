class MenusController < ApplicationController
  def index
    menus = menus_query
    date_range = date_range(params[:start_date], params[:end_date])
    menus = menus.where(date: date_range) if date_range

    total_count = menus.count

    offset = params[:start] || 0
    limit = params[:length] || 100
    menus = menus.offset(offset).limit(limit)

    render json: {
      menus: menus.as_json(only: [:id, :place, :venue, :event, :sponsor, :date]),

      draw: params[:draw],
      recordsTotal: total_count,
      recordsFiltered: total_count
    }
  end

  def show
    menu = Menu.includes(:menu_pages, :dishes).find(params[:id])

    ret = {}
    menu.menu_items.each do |menu_item|
      menu_page = menu_item.menu_page
      dish = menu_item.dish
      ret[menu_page.page_number] ||= []
      ret[menu_page.page_number] << dish.as_json(only: [:id, :name, :description])
    end

    # ensure page order
    pages = ret.sort.map { |_page_number, dishes| dishes }
    render json: {
      name: menu.name,
      place: menu.place,
      venue: menu.venue,
      event: menu.event,
      pages: pages
    }
  end

  private

  def menus_query
    menus = Menu.order('place ASC NULLS LAST')
    menus = menus.where(filters) unless filters.blank?

    # cope with data table order params
    order_info = params[:order]['0']
    return menus unless order_info

    columns = params[:columns]
    column = columns[order_info[:column]][:name]
    return menus if column.blank?

    direction = order_info[:dir]
    menus = menus.reorder("#{column} #{direction} NULLS LAST")
    return menus if column == 'place'

    menus.order('place ASC NULLS LAST')
  end

  def filters
    @filters ||= begin
      columns = params[:columns]
      filters = {}
      columns.each do |_key, column|
        next unless ['place', 'event', 'venue'].include?(column[:name])
        search_value = column[:search][:value]
        next if search_value.blank?

        filters[column[:name]] = search_value
      end

      filters.map do |name, value|
        value = Regexp.escape(value.strip)
        Menu.send(:sanitize_sql_array, ["#{name} ILIKE ?", "%#{value}%"])
      end.join(' AND ')
    end
  end
end
