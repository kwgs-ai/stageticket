class CreateStages < ActiveRecord::Migration[5.2]
  def change
    create_table :stages do |t|
      t.string :status, null: false
      t.string :title, null: false
      t.string :text, null: false
      t.date :date, null: false
      t.string :actor, null: false
      t.string :time, null: false
      t.timestamps
    end
  end
end
