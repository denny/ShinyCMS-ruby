class CreateSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :settings, if_not_exists: true do |t|
      t.string :name, null: false
      t.string :value
      t.string :description

      t.timestamps
    end
  end
end
