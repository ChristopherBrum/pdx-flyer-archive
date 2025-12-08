# frozen_string_literal: true

class VenuesController < ApplicationController
  def new
  end

  def create
  end

  def show
    @venue ||= Venue.find(show_params[:id])
  end

  def index
    @venues ||= Venue.all
  end

  def search
    query = params[:q].to_s.downcase
    @venues = Venue.where("LOWER(name) LIKE ?", "%#{query}%").limit(10)
    render json: @venues
  end

  private

  def show_params
    params.permit(:id)
  end
end
