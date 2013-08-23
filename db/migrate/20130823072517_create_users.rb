class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :password
      t.string :username
      t.integer :logins
      t.integer :active_time
      t.datetime :last_active

      t.timestamps
    end
  end
end
