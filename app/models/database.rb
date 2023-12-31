class Database < ApplicationRecord
  belongs_to :servidor

  def self.sum_transacciones_por_criterios(nombres: nil, servidor_id: nil, start_date: nil, end_date: nil)
    query = self
    query = query.where(nombre: nombres) if nombres.present?
    query = query.where(servidor_id: servidor_id) if servidor_id.present?
    query = query.where(fechaTransaccion: start_date..end_date) if start_date.present? && end_date.present?
    
    query.sum(:transacciones)
  end

  def self.transacciones_totales_por_database(nombres: nil, servidor_id: nil, start_date: nil, end_date: nil)
    query = self
    query = query.where(nombre: nombres) if nombres.present?
    query = query.where(servidor_id: servidor_id) if servidor_id.present?
    query = query.where(fechaTransaccion: start_date..end_date) if start_date.present? && end_date.present?

    query.group(:nombre).sum(:transacciones)
  end

end
