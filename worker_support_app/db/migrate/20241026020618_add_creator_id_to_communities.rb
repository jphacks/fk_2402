class AddCreatorIdToCommunities < ActiveRecord::Migration[7.2]
  def change
    add_column :communities, :creator_id, :integer
  end
end
