# frozen_string_literal: true

class BandsController < ApplicationController
  def new
  end

  def create
  end

  def show
    @band ||= Band.find(show_params[:id])
  end

  def index
    @bands ||= Band.all
  end

  def search
    query = params[:q].to_s.downcase
    @bands = Band.where("LOWER(name) LIKE ?", "%#{query}%").limit(10)
    render json: @bands
  end

  private

  def show_params
    params.permit(:id)
  end
end
