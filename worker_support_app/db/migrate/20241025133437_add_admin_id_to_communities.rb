class AddAdminIdToCommunities < ActiveRecord::Migration[7.2]
  def change
    add_column :communities, :admin_id, :integer
  end
end
