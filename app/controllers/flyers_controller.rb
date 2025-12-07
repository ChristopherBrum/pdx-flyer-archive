# frozen_string_literal: true

class FlyersController < ApplicationController
  def new
  end

  def create
  end

  def show
    @flyer ||= Flyer.find(show_params[:id])
  end

  def edit
  end

  def index
    @flyers ||= Flyer.all
  end

  private

  def show_params
    params.permit(:id)
  end
end
