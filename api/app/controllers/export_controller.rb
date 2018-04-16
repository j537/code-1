class ExportController < ApplicationController
  def menus
    menus = Menu

    send_data menus.to_json,
              type: 'application/json; header=present',
              disposition: 'attachment; filename=users.json'
  end

  private

  def filters
    @filters ||= begin
                  {}
    end
  end
end