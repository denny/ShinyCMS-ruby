class CreateCommentAuthors < ActiveRecord::Migration[6.0]
  def change
    create_table :comment_authors do |t|
      t.string :name, null: false
      t.string :website
      t.inet :ip_address, null: false
      t.uuid :token, null: false

      t.references :email_recipient, null: true

      t.timestamps
    end
  end
end
