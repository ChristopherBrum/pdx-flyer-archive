# frozen_string_literal: true

class Api::SearchController < Api::BaseController
  def index
    query = params[:q].to_s.strip

    if query.blank?
      render json: { flyers: [] }
      return
    end

    # Search for flyers by venue name or band name
    # Use subquery to get distinct flyer IDs first, then fetch full records
    flyer_ids = Flyer.left_joins(:venue, :bands)
                     .where(
                       "LOWER(venues.name) LIKE ? OR LOWER(bands.name) LIKE ?",
                       "%#{query.downcase}%",
                       "%#{query.downcase}%"
                     )
                     .select("DISTINCT flyers.id")
                     .pluck(:id)

    # Now fetch the full flyer records with associations and order them
    flyers = Flyer.includes(:venue, :bands, image_attachment: :blob)
                  .where(id: flyer_ids)
                  .order(event_date: :desc, created_at: :desc)
                  .limit(10)

    render json: {
      flyers: flyers.map do |f|
        {
          id: f.id,
          title: f.title,
          venue: f.venue&.name,
          bands: f.bands.map(&:name),
          event_date: f.event_date&.strftime("%B %d, %Y"),
          image_url: f.image.attached? ? url_for(f.image) : nil
        }
      end
    }
  end
end
