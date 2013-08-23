class CreateGuests < ActiveRecord::Migration
  def change
    create_table :guests do |t|
      t.integer :active_time
      t.string :gid
      t.datetime :last_active

      t.timestamps
    end
  end
end
