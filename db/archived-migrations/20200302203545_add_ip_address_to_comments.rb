class AddIpAddressToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :ip_address, :string
  end
end
