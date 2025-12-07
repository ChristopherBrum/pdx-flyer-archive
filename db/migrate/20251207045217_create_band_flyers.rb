class CreateBandFlyers < ActiveRecord::Migration[8.0]
  def change
    create_table :band_flyers do |t|
      t.references :band, null: false, foreign_key: true
      t.references :flyer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
