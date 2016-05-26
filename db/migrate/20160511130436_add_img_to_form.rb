class AddImgToForm < ActiveRecord::Migration
  def change
    add_column :forms, :img, :string
  end
end
