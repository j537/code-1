class ApplicationController < ActionController::API
  rescue_from Errors::ApplicationError, with: :render_app_error

  def render_app_error(app_error)
    render json: app_error.to_json, status: app_error.class::STATUS
  end
end
