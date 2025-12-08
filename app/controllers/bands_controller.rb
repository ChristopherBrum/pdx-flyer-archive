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
    @pagy, @bands = pagy(Band.all)
  end

  private

  def show_params
    params.permit(:id)
  end
end
