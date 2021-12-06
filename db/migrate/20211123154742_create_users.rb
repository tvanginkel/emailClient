# frozen_string_literal: true

# Create user model
class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email, null: false, default: ''
      t.string :password, null: false, default: ''

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
