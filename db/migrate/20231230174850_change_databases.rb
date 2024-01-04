class ChangeDatabases < ActiveRecord::Migration[7.0]
  def change
    remove_column :databases, :transaccionesDia, :integer
    remove_column :databases, :transaccionesMes, :integer
    add_column :databases, :transacciones, :integer
    add_column :databases, :fechaTransaccion, :date
  end
end
