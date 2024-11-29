class CreateUserAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :user_accounts do |t|
      t.bigint     :owner_id,   null: false
      t.references :currency,   null: false, foreign_key: true
      t.decimal    :balance,    null: false, precision: 10, scale: 2
      t.integer    :status,     null: false
      t.datetime   :deleted_at, null: true,  index: true

      t.timestamps
    end

    add_index :user_accounts, :owner_id
  end
end
