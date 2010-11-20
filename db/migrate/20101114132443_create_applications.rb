class CreateApplications < ActiveRecord::Migration
  def self.up
    create_table :applications do |t|
      t.integer :user_id
      t.string :topic
      t.integer :reaction
      t.integer :closed_by_user_id
      t.integer :category_id
      t.integer :to_user_id
      t.integer :important
      t.text :content
      t.datetime :close_date
      t.integer :execution

      t.timestamps
    end
  end

  def self.down
    drop_table :applications
  end
end
