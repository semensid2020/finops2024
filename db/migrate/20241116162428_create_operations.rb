class CreateOperations < ActiveRecord::Migration[7.0]
  def change
    create_table :operations do |t|
      t.references :sender,        null: false, foreign_key: { to_table: :user_accounts }
      t.references :recipient,     null: false, foreign_key: { to_table: :user_accounts }
      t.references :currency,      null: false, foreign_key: true
      t.decimal    :amount,        null: false, precision: 10, scale: 2
      t.integer    :temporal_type, null: false
      t.integer    :state,         null: false, default: 0
      t.datetime   :planned_at,    null: true, index: true
      t.datetime   :deleted_at,    null: true, index: true

      t.timestamps
    end
  end
end
