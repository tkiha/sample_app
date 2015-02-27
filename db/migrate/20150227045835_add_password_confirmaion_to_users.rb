class AddPasswordConfirmaionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_confirmaion, :string
  end
end
