class CreateUseraccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :useraccounts do |t|
      t.string :user_name, null: false
      t.string :user_ID, null: false
      t.string :password_digest
      t.timestamps
    end
  end
end
