class CreateDatabases < ActiveRecord::Migration[7.0]
  def change
    create_table :databases do |t|
      t.string :nombre
      t.integer :transaccionesDia
      t.integer :transaccionesMes
      t.references :servidor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
