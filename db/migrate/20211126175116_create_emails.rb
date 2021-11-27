class CreateEmails < ActiveRecord::Migration[6.1]
  def change
    create_table :emails do |t|
      t.string :from, null: false
      t.string :to, null: false
      t.string :content, default: ''
      t.string :subject, null: false, default: 'No subject'
      t.integer :mail_box_id, null: false

      t.timestamps
    end
    add_foreign_key :emails, :mail_boxes
  end
end
