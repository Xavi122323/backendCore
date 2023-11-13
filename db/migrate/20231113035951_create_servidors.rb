class CreateServidors < ActiveRecord::Migration[7.0]
  def change
    create_table :servidors do |t|
      t.string :nombre
      t.string :direccionIP
      t.string :SO
      t.string :motorBase

      t.timestamps
    end
  end
end
