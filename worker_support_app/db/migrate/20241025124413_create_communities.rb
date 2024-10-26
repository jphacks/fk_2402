class CreateCommunities < ActiveRecord::Migration[7.2]
  def change
    create_table :communities do |t|
      t.string :name
      t.text :abstruct

      t.timestamps
    end
  end
end
