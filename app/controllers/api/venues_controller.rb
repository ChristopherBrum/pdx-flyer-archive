# frozen_string_literal: true

module Api
  class VenuesController < Api::BaseController
    def index
      @venues = Venue.search_by_name(params[:q])
      render json: @venues
    end
  end
end
