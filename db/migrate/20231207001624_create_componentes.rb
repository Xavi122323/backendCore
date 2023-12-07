class CreateComponentes < ActiveRecord::Migration[7.0]
  def change
    create_table :componentes do |t|
      t.integer :nroCPU
      t.integer :memoria
      t.integer :almacenamiento
      t.references :servidor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
