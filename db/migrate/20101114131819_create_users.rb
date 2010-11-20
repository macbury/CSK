class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :login
      t.string :name
      t.string :surname
      t.string :password
      t.string :email
      t.text :about
      t.text :about_band
      t.text :about_admin
      t.integer :role, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
