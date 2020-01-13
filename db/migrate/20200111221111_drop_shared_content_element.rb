class DropSharedContentElement < ActiveRecord::Migration[6.0]
  def change
    drop_table :shared_content_elements
  end
end
