class CreateMetricas < ActiveRecord::Migration[7.0]
  def change
    create_table :metricas do |t|
      t.float :usoCPU
      t.float :usoMemoria
      t.float :usoAlmacenamiento
      t.datetime :fechaRecoleccion
      t.references :servidor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
