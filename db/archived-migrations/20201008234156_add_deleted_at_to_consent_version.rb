class AddDeletedAtToConsentVersion < ActiveRecord::Migration[6.0]
  def change
    add_column :consent_versions, :deleted_at, :timestamp
    add_index :consent_versions, :deleted_at
  end
end
