# frozen_string_literal: true

module FlyerAssociationHandler
  extend ActiveSupport::Concern

  private

  def handle_flyer_associations(flyer)
    handle_venue_association(flyer)
    handle_band_associations(flyer)
  end

  def handle_venue_association(flyer)
    venue_id = params[:flyer][:venue_id]
    venue_name = params[:venue_search]
    flyer.assign_venue_from_params(venue_id, venue_name)
  end

  def handle_band_associations(flyer, clear_existing: false)
    return unless params[:band_ids_json].present?

    flyer.assign_bands_from_json(params[:band_ids_json], clear_existing: clear_existing)
  end
end
