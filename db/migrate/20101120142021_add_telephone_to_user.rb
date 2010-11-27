class AddTelephoneToUser < ActiveRecord::Migration
  def self.up
    add_column :dm_user, :phone, :string
		add_column :dm_user, :name, :string
		add_column :dm_user, :surname, :string
    add_column :dm_user, :about, :text
    add_column :dm_user, :about_band, :text
    add_column :dm_user, :about_admin, :text
    add_column :dm_user, :role, :integer, :default => 0
  end

  def self.down

  end
end
