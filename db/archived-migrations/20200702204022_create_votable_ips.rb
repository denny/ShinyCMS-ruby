# frozen_string_literal: true

class CreateVotableIps < ActiveRecord::Migration[6.0]
  def change
    create_table :votable_ips do |t|
      t.string :ip_address, null: false

      t.timestamps
    end
  end
end
