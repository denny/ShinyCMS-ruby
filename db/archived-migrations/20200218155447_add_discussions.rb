class AddDiscussions < ActiveRecord::Migration[6.0]
  def change
    create_table :discussions, if_not_exists: true do |t|
      t.references :resource, polymorphic: true

      t.boolean :locked, null: false, default: false
      t.boolean :hidden, null: false, default: false

      t.timestamps
    end
  end
end
