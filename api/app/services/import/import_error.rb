module Import
  class ImportError < StandardError
    def initialize(message, row_num = nil)
      message = "Failed on row #{row_num}: #{message}" if row_num
      super(message)
    end
  end
end


