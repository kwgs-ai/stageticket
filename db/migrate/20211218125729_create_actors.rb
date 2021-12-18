class CreateActors < ActiveRecord::Migration[5.2]
  def change
    create_table :actors do |t|
      t.string :name, null: false
      t.string :login_name, null: false
      t.string :password_digest
      t.timestamps
    end
  end
end
