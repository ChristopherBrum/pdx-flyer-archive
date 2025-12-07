class CreateFlyers < ActiveRecord::Migration[8.0]
  def change
    create_table :flyers do |t|
      t.string :title
      t.date :event_date
      t.references :venue, null: false, foreign_key: true
      t.text :notes

      t.timestamps
    end
  end
end
