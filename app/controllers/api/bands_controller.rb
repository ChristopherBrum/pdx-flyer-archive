# frozen_string_literal: true

module Api
  class BandsController < Api::BaseController
    def index
      @bands = Band.search_by_name(params[:q])
      render json: @bands
    end
  end
end
