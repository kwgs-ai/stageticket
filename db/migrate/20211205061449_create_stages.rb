class CreateStages < ActiveRecord::Migration[5.2]
  def change
    create_table :stages do |t|
      t.references :actor, null: false
      t.references :category, null: false
      t.integer :status, null: false, default: 1
      t.string :title, null: false
      t.string :text, null: false
      t.date :date, null: false
      t.integer :time, null: false
      t.timestamps
    end
  end
end

