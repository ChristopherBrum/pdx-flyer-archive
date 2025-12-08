# frozen_string_literal: true

class FlyersController < ApplicationController
  def new
    @flyer ||= Flyer.new
  end

  def create
    @flyer = Flyer.new(flyer_params)

    # Handle venue: either find existing or create new
    venue_id = params[:flyer][:venue_id]
    venue_name = params[:venue_search]

    if venue_id.present?
      @flyer.venue = Venue.find(venue_id)
    elsif venue_name.present?
      @flyer.venue = Venue.find_or_create_by(name: venue_name.strip)
    end

    # Handle bands: parse JSON and create/find each band
    if params[:band_ids_json].present?
      begin
        bands_data = JSON.parse(params[:band_ids_json])
        bands_data.each do |band_data|
          if band_data["id"].present?
            # Existing band
            band = Band.find_by(id: band_data["id"])
            @flyer.bands << band if band && !@flyer.bands.include?(band)
          elsif band_data["name"].present?
            # New band
            band = Band.find_or_create_by(name: band_data["name"].strip)
            @flyer.bands << band unless @flyer.bands.include?(band)
          end
        end
      rescue JSON::ParserError => e
        Rails.logger.error("Failed to parse band_ids_json: #{e.message}")
      end
    end

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

    # Handle venue: either find existing or create new
    venue_id = params[:flyer][:venue_id]
    venue_name = params[:venue_search]

    if venue_id.present?
      @flyer.venue = Venue.find(venue_id)
    elsif venue_name.present?
      @flyer.venue = Venue.find_or_create_by(name: venue_name.strip)
    end

    # Handle bands: parse JSON and replace all bands
    if params[:band_ids_json].present?
      begin
        bands_data = JSON.parse(params[:band_ids_json])
        @flyer.bands = []  # Clear existing associations
        bands_data.each do |band_data|
          if band_data["id"].present?
            # Existing band
            band = Band.find_by(id: band_data["id"])
            @flyer.bands << band if band
          elsif band_data["name"].present?
            # New band
            band = Band.find_or_create_by(name: band_data["name"].strip)
            @flyer.bands << band
          end
        end
      rescue JSON::ParserError => e
        Rails.logger.error("Failed to parse band_ids_json: #{e.message}")
      end
    end

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
    @flyers ||= Flyer.all
  end

  private

  def flyer_params
    params.require(:flyer).permit(:title, :event_date, :notes, :image, :venue_id)
  end

  def show_params
    params.permit(:id)
  end
end
