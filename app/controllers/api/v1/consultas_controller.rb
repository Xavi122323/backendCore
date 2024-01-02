class Api::V1::ConsultasController < ApplicationController

  def uso_cpu_promedio
    server_id = params[:server_id]
    start_date = params[:start_date]
    end_date = params[:end_date]

    if server_id.present? && start_date.present? && end_date.present?
      average_cpu = Metrica.where(servidor_id: server_id)
                          .where('"fechaRecoleccion" >= ?', start_date)
                          .where('"fechaRecoleccion" <= ?', end_date)
                          .average(:usoCPU)
      unless average_cpu.nil?
        render json: { server_id: server_id, average_cpu: average_cpu }
      else
        render json: { error: "No data found for the specified criteria" }, status: :not_found
      end
    else
      render json: { error: "Missing parameters" }, status: :bad_request
    end
  end

  def cpu_fechas
    server_id = params[:server_id]
    start_date = params[:start_date]
    end_date = params[:end_date]

    if server_id.present? && start_date.present? && end_date.present?
      metricas = Metrica.where(servidor_id: server_id)
                        .where('"fechaRecoleccion" >= ?', start_date)
                        .where('"fechaRecoleccion" <= ?', end_date)
                        .select(:fechaRecoleccion, :usoCPU, :id)

      if metricas.any?
        formatted_metricas = metricas.map do |metrica|
          metrica.attributes.merge('fechaRecoleccion' => metrica.fechaRecoleccion.strftime("%Y-%m-%d"))
        end
        render json: formatted_metricas, status: 200
      else
        render json: { error: "No data found for the specified criteria" }, status: :not_found
      end
    else
      render json: { error: "Missing parameters" }, status: :bad_request
    end
  end

  def uso_memoria_promedio
    server_id = params[:server_id]
    start_date = params[:start_date]
    end_date = params[:end_date]

    if server_id.present? && start_date.present? && end_date.present?
      average_memoria = Metrica.where(servidor_id: server_id)
                          .where('"fechaRecoleccion" >= ?', start_date)
                          .where('"fechaRecoleccion" <= ?', end_date)
                          .average(:usoMemoria)
      unless average_memoria.nil?
        render json: { server_id: server_id, average_memoria: average_memoria }
      else
        render json: { error: "No data found for the specified criteria" }, status: :not_found
      end
    else
      render json: { error: "Missing parameters" }, status: :bad_request
    end
  end

  def memoria_fechas
    server_id = params[:server_id]
    start_date = params[:start_date]
    end_date = params[:end_date]

    if server_id.present? && start_date.present? && end_date.present?
      metricas = Metrica.where(servidor_id: server_id)
                        .where('"fechaRecoleccion" >= ?', start_date)
                        .where('"fechaRecoleccion" <= ?', end_date)
                        .select(:fechaRecoleccion, :usoMemoria, :id)

      if metricas.any?
        formatted_metricas = metricas.map do |metrica|
          metrica.attributes.merge('fechaRecoleccion' => metrica.fechaRecoleccion.strftime("%Y-%m-%d"))
        end
        render json: formatted_metricas, status: 200
      else
        render json: { error: "No data found for the specified criteria" }, status: :not_found
      end
    else
      render json: { error: "Missing parameters" }, status: :bad_request
    end
  end

  def suma_transacciones
    sum = Database.sum_transacciones_por_criterios(
      nombres: params[:nombres],
      servidor_id: params[:servidor_id],
      start_date: params[:start_date],
      end_date: params[:end_date]
    )

    if sum == 'no_data'
      render json: { error: 'No data available for the given criteria' }, status: :not_found
    else
      render json: { sum: sum }
    end

  end

  def transacciones_totales
    transaction_data = Database.transacciones_totales_por_database(
      nombres: params[:nombres],
      servidor_id: params[:servidor_id],
      start_date: params[:start_date],
      end_date: params[:end_date]
    )

    if transaction_data == 'no_data'
      render json: { error: 'No data available for the given criteria' }, status: :not_found
    else
      transacciones = transaction_data.map do |nombre, total_transacciones|
        { nombre: nombre, total_transacciones: total_transacciones }
      end
      render json: transacciones, status: 200
    end

    #render json: transaction_data
  end

end
