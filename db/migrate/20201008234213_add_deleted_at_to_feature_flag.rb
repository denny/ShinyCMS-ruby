class AddDeletedAtToFeatureFlag < ActiveRecord::Migration[6.0]
  def change
    add_column :feature_flags, :deleted_at, :timestamp, precision: 6
    add_index :feature_flags, :deleted_at
  end
end
