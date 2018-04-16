require 'rails_helper'

RSpec.describe Import::CopyImporter do
  let(:csv) do
    Rails.root.join('spec', 'data', 'dishes.csv')
  end

  describe '#import' do
    let(:expected_results) do
      [
        { id: 1, name: 'Consomme printaniere royal' },
        { id: 2, name: 'Chicken gumbo' },
        { id: 3, name: 'Tomato aux croutons' },
        { id: 4, name: 'Onion au gratin' },
        { id: 5, name: 'St. Emilion' }
      ]
    end

    it 'imports correct data' do
      importer = Import::CopyImporter.new(Dish, path: csv)
      importer.import

      expect(Dish.count).to be 5
      expect(Dish.all.as_json(only: %i[id name])).to match expected_results.as_json
    end
  end
end