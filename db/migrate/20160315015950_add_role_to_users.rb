class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :integer, default: "normal"
  end
end
