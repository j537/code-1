require 'rails_helper'

RSpec.describe Import::BulkImporter do
  describe '#import' do
    context 'with path missing required headers' do
      let(:missing_headers) { %i[menu_page_id dish_id] }
      let(:csv_with_missing_headers) do
        Rails.root.join('spec', 'data', 'invalid_menu_items_with_missing_headers.csv')
      end

      it 'throws an error with missing header' do
        importer = Import::BulkImporter.new(MenuItem, path: csv_with_missing_headers)

        expect do
          importer.import
        end.to raise_error(Import::ImportError, "Failed on row 1: Missing headers: #{missing_headers.join(', ')}")
      end
    end

    context 'with valid csv files' do
      let(:csv) do
        Rails.root.join('spec', 'data', 'menus.csv')
      end

      let(:expected_results) do
        [
          { id: 12_463, sponsor: 'HOTEL EASTMAN', event: 'BREAKFAST', venue: 'COMMERCIAL' },
          { id: 12_464, sponsor: 'REPUBLICAN HOUSE', event: '[DINNER]', venue: 'COMMERCIAL' }
        ]
      end

      it 'imports correct data' do
        importer = Import::BulkImporter.new(Menu, path: csv)
        importer.import

        expect(Menu.count).to be 2
        expect(Menu.all.as_json(only: %i[id sponsor event venue])).to match expected_results.as_json
      end
    end
  end
end