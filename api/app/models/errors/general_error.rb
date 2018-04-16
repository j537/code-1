module Errors
  class GeneralError < ApplicationError
    def initialize(detail = '')
      super('General Error', detail: detail)
    end
  end
end
