class CreateReservations < ActiveRecord::Migration[5.2]
  def change
    create_table :reservations do |t|
      t.references :useraccount, null: false
      t.references :stage
      t.string :seat, null: false
      t.timestamps
    end
  end
end
