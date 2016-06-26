class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, if: :json_request?

  def json_request?
    request.format.json?
  end

  rescue_from StandardError do |e|
    logger.error "#{e.class} : #{e.message} "
    render status: 500, json: { error: "Internal Server Error" }
  end
end
