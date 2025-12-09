# frozen_string_literal: true

class Api::BaseController < ApplicationController
  # Skip CSRF token verification for API requests
  skip_before_action :verify_authenticity_token, raise: false
end
