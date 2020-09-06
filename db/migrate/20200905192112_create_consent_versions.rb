class CreateConsentVersions < ActiveRecord::Migration[6.0]
  def change
    drop_table :consents

    create_table :consent_versions do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :full_text, null: false
      t.text :notes

      t.timestamps
    end
  end
end
