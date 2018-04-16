require 'csv'

module Import
    class CopyImporter
      attr_reader :model_klass

      # @param model_klass [ApplicationRecord] active record model class
      # @param path [String] csv file path to import from
      def initialize(model_klass, path:)
        @model_klass = model_klass
        @path = path

        @table_name = model_klass.table_name
        @tmp_table_name = "tmp_#{@table_name}"
      end

      def import
        validate_headers!(headers)

        db_conn.transaction do
          copy_to_tmp_table
          copy_to_table
        end
      end

      private

      def db_conn
        @db_conn ||= begin
          conn = ActiveRecord::Base.connection
          conn.raw_connection
        end
      end

      def headers
        @headers ||= begin
          ret = []
          CSV.foreach(@path, headers: true) do |row|
            ret = row.headers
            break
          end

          ret
        end
      end

      def copy_to_tmp_table
        # create tmp table based on model class table
        db_conn.exec(%(
          CREATE TEMP TABLE #{@tmp_table_name} (LIKE #{@table_name})
          ON COMMIT DROP;
        ))

        # copy  data into tmp table
        db_conn.exec("COPY #{@tmp_table_name} (#{headers.join(', ')}) FROM STDIN WITH CSV HEADER")

        file = File.open(@path, 'r')
        until file.eof?
          # Add row to copy data
          line = file.readline
          db_conn.put_copy_data(line)
        end

        db_conn.put_copy_end

        # Display any error messages
        while res = db_conn.get_result
          e_message = res.error_message
          Rails.logger.error e_message unless e_message.blank?
        end
      end

      def copy_to_table
        set_clause = @model_klass.column_names.map do |col|
          "#{col} = EXCLUDED.#{col}"
        end.join(', ')

        db_conn.exec(%(
        INSERT INTO #{@table_name} SELECT * from #{@tmp_table_name}
        ON CONFLICT(id) DO UPDATE
        SET #{set_clause};
      ))
      end

      def validate_headers!(headers)
        missing_headers = model_klass.column_names - headers
        return if missing_headers.empty?

        raise ImportError.new("Missing headers: #{missing_headers.join(', ')}", 1)
      end
    end
  end
