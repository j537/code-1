class ImportController < ApplicationController
  before_action :set_import_file

  def menus
    Import::BulkImporter.new(Menu, path: @import_file.path).import
    head :no_content
  end

  def dishes
    Import::CopyImporter.new(Dish, path: @import_file.path).import
    head :no_content
  end

  def menu_items
    Import::CopyImporter.new(MenuItem, path: @import_file.path).import
    head :no_content
  end

  def menu_pages
    Import::CopyImporter.new(MenuPage, path: @import_file.path).import
    head :no_content
  end

  private

  def set_import_file
    raise Errors::GeneralError, 'import file is not found' if params[:import_file].nil?

    @import_file = params[:import_file]
  end
end
