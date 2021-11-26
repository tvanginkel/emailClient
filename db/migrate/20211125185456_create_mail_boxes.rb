# frozen_string_literal: true

# Mailboxes
class CreateMailBoxes < ActiveRecord::Migration[6.1]
  def change
    create_table :mail_boxes do |t|
      t.string :name, null: false, default: ''
      t.integer :user_id, null: false

      t.timestamps
    end

    add_index :mail_boxes, :name, unique: true
    add_foreign_key :mail_boxes, :users
  end
end
