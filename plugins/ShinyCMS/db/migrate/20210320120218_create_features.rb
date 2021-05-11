# frozen_string_literal: true

require 'active_support/core_ext'

class CreateFeatures < ActiveRecord::Migration[6.1]
  def self.up
    create_table :features do |t|
      t.string   :symbol, :null => false
      t.integer  :deployment_percentage, :null => false
      #Any additional fields here

      t.timestamps
    end
  end

  def self.down
    drop_table :features
  end
end
