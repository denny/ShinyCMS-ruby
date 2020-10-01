class CreateConsents < ActiveRecord::Migration[6.0]
  def change
    create_table :consents do |t|
      t.string :purpose_type, null: false
      t.integer :purpose_id, null: false

      t.string :action, null: false
      t.text :wording, null: false
      t.string :url

      t.timestamps
    end
  end
end
