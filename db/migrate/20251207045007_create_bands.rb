class CreateBands < ActiveRecord::Migration[8.0]
  def change
    create_table :bands do |t|
      t.string :name
      t.string :website
      t.string :city
      t.string :state
      t.string :country

      t.timestamps
    end
  end
end
