class CreateAhoyMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :ahoy_messages do |t|
      t.references :user, polymorphic: true
      t.text :to
      t.string :mailer
      t.text :subject
      t.string :token
      t.timestamp :sent_at
      t.timestamp :opened_at
      t.timestamp :clicked_at
    end
    add_index :ahoy_messages, :token
  end
end
