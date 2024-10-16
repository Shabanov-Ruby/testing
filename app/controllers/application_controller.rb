# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordInvalid, with: :error_handling
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

  private

  def error_handling(exception)
    flash[:notice] = exception.record.errors.messages[:content].join(', ')
    redirect_to root_path
  end
end
