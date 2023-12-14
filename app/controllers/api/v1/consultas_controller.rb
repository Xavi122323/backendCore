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
      render json: { server_id: server_id, average_cpu: average_cpu }
    else
      render json: { error: "Missing parameters" }, status: :bad_request
    end
  end

end
