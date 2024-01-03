class Api::V1::MetricaController < ApplicationController
  
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authenticate_dba!, only: [:update, :create, :destroy]

  def index
    @metrica = Metrica.includes(:servidor).all()
    
    if params[:servidor]
      @metrica = @metrica.joins(:servidor).where("servidors.nombre LIKE ?", "%#{params[:servidor]}%")
    end

    if params[:fechaRecoleccion]
      date = Date.parse(params[:fechaRecoleccion])
      @metrica = @metrica.where('CAST("fechaRecoleccion" AS DATE) = ?', date)
    end

    render json: @metrica.map { |metrica|
      metrica.as_json.merge({ server_name: metrica.servidor.nombre })
    }
  end

  def show
    @metrica = Metrica.find(params[:id])
    if @metrica
      render json:@metrica, status: 200
    else
      render json: {error: "Metrica no encontrada"}
    end
  end

  def new
    @metrica = Metrica.new
  end

  def create
    @metrica = Metrica.new(metrica_params_with_parsed_date)

    if @metrica.save
      render json: @metrica, status: :created
    else
      render json: { errors: @metrica.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @metrica = Metrica.find(params[:id])

    if @metrica.update(metrica_params_with_parsed_date)
      render json: { message: "Actualizado exitosamente" }
    else
      render json: { error: "No se pudo actualizar", errors: @metrica.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @metrica = Metrica.find(params[:id])
    if @metrica
      @metrica.destroy
      render json: {message: "Eliminado exitosamente"}
    else
      render json: { error: 'No se pudo eliminar la Metrica', errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def metrica_params
    params.permit(:usoCPU, :usoMemoria, :usoAlmacenamiento, :fechaRecoleccion, :servidor_id)
  end

  def metrica_params_with_parsed_date
    metrica_parameters = metrica_params
    if metrica_parameters[:fechaRecoleccion].present?
      metrica_parameters[:fechaRecoleccion] = DateTime.parse(metrica_parameters[:fechaRecoleccion])
    end
    metrica_parameters
  end

end
