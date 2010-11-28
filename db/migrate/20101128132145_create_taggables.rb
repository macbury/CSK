class CreateTaggables < ActiveRecord::Migration
  def self.up
    create_table :taggables do |t|
      t.integer :category_id
      t.integer :application_id

      t.timestamps
    end

		remove_column :applications, :category_id
  end

  def self.down
    drop_table :taggables
  end
end
