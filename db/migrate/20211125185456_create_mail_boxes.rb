# frozen_string_literal: true

# Mailboxes
class CreateMailBoxes < ActiveRecord::Migration[6.1]
  def change
    create_table :mail_boxes do |t|
      t.string :name, null: false, default: 'no_name'
      t.integer :user_id, null: false

      t.timestamps
    end

    add_foreign_key :mail_boxes, :users
  end
end
