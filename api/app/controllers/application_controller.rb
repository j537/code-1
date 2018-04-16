class ApplicationController < ActionController::API
  rescue_from Errors::ApplicationError, with: :render_app_error

  def render_app_error(app_error)
    render json: app_error.to_json, status: app_error.class::STATUS
  end

  protected

  def date_range(start_date, end_date)
    return nil if start_date.blank? || end_date.blank?

    begin
      start_date = Date.parse(start_date)
      end_date = Date.parse(end_date)
    rescue ArgumentError => e
      raise ::Errors::GeneralError, e.message
    end

    if start_date > end_date
      raise Errors::GeneralError, 'invalid date range: start date is after end date'
    end

    (start_date..end_date)
  end
end
