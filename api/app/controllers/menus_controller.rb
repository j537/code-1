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

  private

  def menus_query
    menus = Menu.order('place ASC NULLS LAST')
    menus = menus.where(filters) unless filters.blank?

    # try cope with data table order params
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

  def date_range(start_date, end_date)
    return nil if start_date.blank? || end_date.blank?

    begin
      start_date = Date.parse(start_date)
      end_date = Date.parse(end_date)
    rescue ArgumentError => e
      raise ::Errors::GeneralError, e.message
    end

    if start_date > end_date
      raise Errors::GeneralError, 'invalid date range: start date is after end date'
    end

    (start_date..end_date)
  end
end
