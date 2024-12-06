class CreateCurrencies < ActiveRecord::Migration[7.0]
  def change
    create_table :currencies do |t|
      t.string   :name,       null: false
      t.string   :code,       null: false
      t.datetime :deleted_at, null: true, index: true

      t.timestamps
    end

    add_index :currencies, :name, unique: true
    add_index :currencies, :code, unique: true
  end
end
