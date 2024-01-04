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

  def compare
    server_ids = comparison_params[:server_ids]
    start_date = comparison_params[:start_date]
    end_date = comparison_params[:end_date]
    params_to_compare = comparison_params[:params]
  
    if server_ids.empty? || params_to_compare.empty?
      render json: { error: 'Missing required parameters' }, status: :bad_request
      return
    end
  
    most_transactions = { server_name: nil, transaction_count: 0 }
    least_efficient_memory = []
  
    @comparison_results = server_ids.map do |id|
      server = Servidor.find_by(id: id)
      unless server
        render json: { error: "Server with id #{id} not found" }, status: :not_found
        next
      end
  
      metrics = server.metricas.where(fechaRecoleccion: start_date..end_date)
      server_result = {
        servidor: server.nombre,
        cpu_usage: include_param?('CPU', params_to_compare) ? metrics_data(metrics, :usoCPU) : nil,
        memoria_usage: include_param?('Memoria', params_to_compare) ? metrics_data(metrics, :usoMemoria) : nil,
        almacenamiento_usage: include_param?('Almacenamiento', params_to_compare) ? metrics_data(metrics, :usoAlmacenamiento) : nil,
        transacciones: include_param?('Transacciones', params_to_compare) ? transaction_data(server, start_date, end_date) : nil
      }
  
      # Update most transactions and least efficient memory usage
      total_transactions = server_result[:transacciones]
      if total_transactions && total_transactions > most_transactions[:transaction_count]
        most_transactions = { server_name: server.nombre, transaction_count: total_transactions }
      end
  
      avg_memory_usage = server_result[:memoria_usage]
      if avg_memory_usage && avg_memory_usage != 'no_data'
        least_efficient_memory << { server_name: server.nombre, average_memory_usage: avg_memory_usage }
      end
  
      server_result
    end
  
    # Sort the memory usage data
    least_efficient_memory.sort_by! { |data| -data[:average_memory_usage] }
  
    # Comparing each server with every other server
    server_comparisons = []
    server_ids.combination(2).each do |id1, id2|
      server1 = @comparison_results.find { |result| result[:servidor] == Servidor.find_by(id: id1).nombre }
      server2 = @comparison_results.find { |result| result[:servidor] == Servidor.find_by(id: id2).nombre }
    
      # Skip comparison if one of the servers is missing in the results
      next unless server1 && server2
    
      # Calculate differences
      transaction_difference = (server1[:transacciones] - server2[:transacciones]).abs
      memory_difference = (server1[:memoria_usage].to_f - server2[:memoria_usage].to_f).abs
    
      server_comparisons << {
        server1: server1[:servidor],
        server2: server2[:servidor],
        transaction_difference: transaction_difference,
        memory_difference: memory_difference
      }
    end
  
    # Summary for most transactions and least efficient memory use
    comparison_summary = {
      most_transactions: most_transactions,
      least_efficient_memory: least_efficient_memory.take(3)
    }
  
    # Render the final JSON response
    render json: { 
      comparison_results: @comparison_results.compact, 
      summary: comparison_summary, 
      server_comparisons: server_comparisons 
    }, status: :ok
  end
  
  

  private

  def metrics_data(metrics, field)
    return 'no_data' if metrics.empty?
    average_metric(metrics, field)
  end

  def transaction_data(server, start_date, end_date)
    server.databases.where(fechaTransaccion: start_date..end_date).sum(:transacciones)
  end

  def include_param?(param, params_to_compare)
    params_to_compare.include?(param)
  end

  def average_metric(metrics, field)
    metrics.average(field).to_f.round(2)
  end

  def comparison_params
    params.require(:comparison).permit(:start_date, :end_date, params: [], server_ids: [])
  end

end
