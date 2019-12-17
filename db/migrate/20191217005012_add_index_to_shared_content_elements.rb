class AddIndexToSharedContentElements < ActiveRecord::Migration[6.0]
  def change
    add_index :shared_content_elements, :name, unique: true
  end
end
