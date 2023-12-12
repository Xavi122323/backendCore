class Api::V1::MetricaController < ApplicationController
  
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authenticate_dba!, only: [:update, :create, :destroy]

  def index
    @metrica = Metrica.includes(:servidor).all()
    #render json:@metrica.as_json(include: :servidor), status: 200
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
    @metrica = Metrica.new(
      usoCPU: metrica_params[:usoCPU], 
      usoMemoria: metrica_params[:usoMemoria], 
      usoAlmacenamiento: metrica_params[:usoAlmacenamiento],
      fechaRecoleccion: metrica_params[:fechaRecoleccion],
      servidor_id: metrica_params[:servidor_id])

    if @metrica.save
      render json:@metrica, status:200
    else
      render json:{error: "No se pudo ingresar"}
    end
  end

  def update
    @metrica = Metrica.find(params[:id])

    if @metrica
      @metrica.update(usoCPU: params[:usoCPU], usoMemoria: params[:usoMemoria], usoAlmacenamiento: params[:usoAlmacenamiento], fechaRecoleccion: params[:fechaRecoleccion], servidor_id: params[:servidor_id])
      render json: {message: "Actualizado exitosamente"}
    else
      render json:{error: "No se pudo actualizar"}
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
      params.require(:Metrica).permit(:usoCPU, :usoMemoria, :usoAlmacenamiento, :fechaRecoleccion, :servidor_id)
    end

end
