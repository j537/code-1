require 'csv'

module Import
    class BulkImporter
      attr_reader :model_klass

      def initialize(model_klass, path:, buffer_size: 10_000)
        @model_klass = model_klass
        @path = path
        @valid_headers = model_klass.column_names.map(&:to_sym)
        @buffer_size = buffer_size

        @required_headers = [:id]
        if model_klass.const_defined?('REQUIRED_HEADERS')
          @required_headers.concat(model_klass.const_get('REQUIRED_HEADERS'))
        end
      end

      def import
        buffered_records = []
        model_klass.transaction do
          CSV.foreach(@path, headers: true, header_converters: :symbol).with_index(1) do |row, row_num|
            validate_headers!(row.headers) if row_num == 1

            begin
              id = Integer(row[:id])
              raise ArgumentError 'must be positive integer' if id < 1
            rescue StandardError
              Rails.logger.error "Failed on row #{row_num}: id is not a positive integer"
              next # silently ignore for now
            end

            # only keep valid headers
            record = model_klass.new
            values = row.to_hash.slice(*@valid_headers)
            record.assign_attributes(values)

            buffered_records << record

            if buffered_records.size == @buffer_size
              bulk_import(buffered_records)
              buffered_records = []
            end
          end

          bulk_import(buffered_records) unless buffered_records.empty?
        end

      rescue StandardError => e
        raise ImportError, e.message
      end

      private

      def bulk_import(records)
        model_klass.import records, on_duplicate_key_update: @valid_headers, validate: false
      end

      def validate_headers!(headers)
        missing_headers = @required_headers - headers
        return if missing_headers.empty?

        raise ImportError.new("Missing headers: #{missing_headers.join(', ')}", 1)
      end
    end
  end
