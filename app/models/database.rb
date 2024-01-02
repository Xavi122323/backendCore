class Database < ApplicationRecord
  belongs_to :servidor

  def self.no_data?(query)
    query.limit(1).empty?
  end

  def self.sum_transacciones_por_criterios(nombres: nil, servidor_id: nil, start_date: nil, end_date: nil)
    query = build_query(nombres: nombres, servidor_id: servidor_id, start_date: start_date, end_date: end_date)
    
    return 'no_data' if query.limit(1).empty?

    query.sum(:transacciones)
  end

  def self.transacciones_totales_por_database(nombres: nil, servidor_id: nil, start_date: nil, end_date: nil)
    query = build_query(nombres: nombres, servidor_id: servidor_id, start_date: start_date, end_date: end_date)

    return 'no_data' if query.limit(1).empty?

    query.group(:nombre).sum(:transacciones)
  end

  def self.build_query(nombres: nil, servidor_id: nil, start_date: nil, end_date: nil)
    query = self
    query = query.where(nombre: nombres) if nombres.present?
    query = query.where(servidor_id: servidor_id) if servidor_id.present?
    query = query.where(fechaTransaccion: start_date..end_date) if start_date.present? && end_date.present?
    query
  end

end
