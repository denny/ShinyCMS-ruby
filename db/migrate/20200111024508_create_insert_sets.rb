class CreateInsertSets < ActiveRecord::Migration[6.0]
  def change
    create_table :insert_sets, if_not_exists: true do |t|

      t.timestamps
    end
  end
end
