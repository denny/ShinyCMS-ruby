class CreateConsentVersions < ActiveRecord::Migration[6.0]
  def change
    drop_table :consents, if_exists: true

    create_table :consent_versions do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :display_text, null: false
      t.text :admin_notes

      t.timestamps
    end
  end
end
