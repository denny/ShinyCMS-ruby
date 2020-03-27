class CreateSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :subscriptions do |t|
      t.integer :list_id, null: false
      t.integer :subscriber_id, null: false
      t.string :subscriber_type, null: false, default: 'EmailRecipient'

      t.timestamps
    end
  end
end
