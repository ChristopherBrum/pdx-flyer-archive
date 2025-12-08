# frozen_string_literal: true

module Api
  class BaseController < ApplicationController
    # Skip CSRF token verification for API requests
    skip_before_action :verify_authenticity_token, raise: false
  end
end
