class CreateSeats < ActiveRecord::Migration[5.2]
  def change
    create_table :seats do |t|
      t.references :stage, null: false
      t.references :reservation
      t.string :seat_type, null: false
      t.integer :cost, null: false

      t.timestamps
    end
  end
end
