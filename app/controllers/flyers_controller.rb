# frozen_string_literal: true

class FlyersController < ApplicationController
  include FlyerAssociationHandler

  def new
    @flyer ||= Flyer.new
  end

  def create
    @flyer = Flyer.new(flyer_params)
    handle_flyer_associations(@flyer)

    if @flyer.save
      redirect_to @flyer, notice: "Flyer created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @flyer ||= Flyer.find(show_params[:id])
  end

  def edit
    @flyer = Flyer.find(params[:id])
  end

  def update
    @flyer = Flyer.find(params[:id])
    @flyer.assign_attributes(flyer_params)
    handle_venue_association(@flyer)
    handle_band_associations(@flyer, clear_existing: true)

    if @flyer.save
      redirect_to @flyer, notice: "Flyer updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @flyer = Flyer.find(params[:id])
    @flyer.destroy
    redirect_to flyers_path, notice: "Flyer deleted successfully."
  end

  def index
    @pagy, @flyers = pagy(Flyer.all)
  end

  private

  def flyer_params
    params.require(:flyer).permit(:title, :event_date, :notes, :image, :venue_id)
  end

  def show_params
    params.permit(:id)
  end
end
