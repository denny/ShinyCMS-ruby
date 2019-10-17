class CreateSharedElements < ActiveRecord::Migration[6.0]
  def change
    create_table :shared_elements do |t|
      t.string :name,  null: false
      t.string :type,  null: false
      t.string :value, null: false

      t.timestamps
    end
  end
end
