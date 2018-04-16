require 'json'

class ExportController < ApplicationController
  PERMITTED_FILTERS = %i[place event venue].freeze

  def menus
    menus = Menu.all.order(:id)

    date_range = date_range(params[:start_date], params[:end_date])
    menus = Menu.where(date: date_range) if date_range
    menus = menus.where(filters) unless filters.blank?

    send_data JSON.pretty_generate(menus.as_json),
              type: 'application/json; header=present',
              filename: 'menus.json'
  end

  private

  def filters
    @filters ||= begin
      filters = {}
      %i[place event venue].each do |key|
        filters[key] = params[key] unless params[key].blank?
      end

      filters.map do |name, value|
        value = Regexp.escape(value.strip)
        Menu.send(:sanitize_sql_array, ["#{name} ILIKE ?", "%#{value}%"])
      end.join(' AND ')
    end
  end
end