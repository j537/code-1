module Errors
  class ApplicationError < StandardError

    attr_reader :title
    attr_reader :detail

    CODE = :general_error # error code
    STATUS = :unprocessable_entity # http status

    def initialize(title, detail: '')
      @title = title
      @detail = detail
      super(detail)
    end

    def code
      self.class::CODE
    end

    def to_json
      { error: { title: title, code: code, detail: detail } }
    end
  end
end
