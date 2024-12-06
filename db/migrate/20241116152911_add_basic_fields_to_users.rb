class AddBasicFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :first_name, :string,   null: false
    add_column :users, :last_name,  :string,   null: false
    add_column :users, :role,       :integer,  null: false
    add_column :users, :deleted_at, :datetime, null: true

    add_index :users, :deleted_at
  end
end
