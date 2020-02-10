class CreateSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :settings do |t|
      t.string :name, null: false
      t.string :description

      t.string :level, null: false, default: 'site'
      t.boolean :locked, null: false, default: true

      t.timestamps
    end
  end
end
