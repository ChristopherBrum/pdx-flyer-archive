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

  private

  def show_params
    params.permit(:id)
  end 
end
