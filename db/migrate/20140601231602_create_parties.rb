class CreateParties < ActiveRecord::Migration
  def change
    create_table :parties do |t|
      t.string :theme
      t.string :location
      t.datetime :when_held
      t.string :host
      t.string :host_email

      t.timestamps
    end
  end
end
