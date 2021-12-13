class CreateStages < ActiveRecord::Migration[5.2]
  def change
    create_table :stages do |t|
      t.references :actoraccount, null: false
      t.boolean :status, null: false, default: false
      t.string :title, null: false
      t.string :text, null: false
      t.date :date, null: false
      t.string :time, null: false
      t.timestamps
    end
  end
end

