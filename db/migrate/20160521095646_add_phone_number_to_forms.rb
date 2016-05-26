class AddPhoneNumberToForms < ActiveRecord::Migration
  def change
    add_column :forms, :phone_number, :string
  end
end
