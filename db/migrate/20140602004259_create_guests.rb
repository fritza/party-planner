class CreateGuests < ActiveRecord::Migration
  def change
    create_table :guests do |t|
      t.string :name
      t.string :email
      t.boolean :rsvp
      t.references :party, index: true

      t.timestamps
    end
  end
end
