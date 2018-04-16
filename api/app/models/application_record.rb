class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.sanitize(value)
    send(:sanitize_sql_for_conditions, value)
  end
end
