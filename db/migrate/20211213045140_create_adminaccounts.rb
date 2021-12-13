class CreateAdminaccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :adminaccounts do |t|
      t.string :admin_name, null: false
      t.string :admin_ID, null: false
      t.string :password_digest

      t.timestamps
    end
  end
end
