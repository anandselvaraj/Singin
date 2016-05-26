class CreateForms < ActiveRecord::Migration
  def change
    create_table :forms do |t|
      t.string :username
      t.string :email
      t.string :password
      t.string :confo_password
      t.string :dob
      t.string :role
      t.string :genter

      t.timestamps null: false
    end
  end
end
