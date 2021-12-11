class CreateActoraccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :actoraccounts do |t|
      t.references :stage, null: false
      t.string :actor_name, null: false
      t.string :actor_ID, null: false
      t.string :password_digest
      t.timestamps
    end
  end
end
