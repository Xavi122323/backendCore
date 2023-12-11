class Api::V1::ComponenteController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :authenticate_dba!, only: [:update, :create, :destroy]

  def index
    @componente = Componente.includes(:servidor).all()
    #render json:@componente.as_json(include: :servidor), status: 200
    render json: @componente.map { |componente|
      componente.as_json.merge({ server_name: componente.servidor.nombre })
    }
  end

  def show
    @componente = Componente.find(params[:id])
    if @componente
      render json:@componente, status: 200
    else
      render json: {error: "Componente no encontrado"}
    end
  end

  def new
    @componente = Componente.new
  end

  def create
    @componente = Componente.new(
      nroCPU: component_params[:nroCPU], 
      memoria: component_params[:memoria], 
      almacenamiento: component_params[:almacenamiento],
      servidor_id: component_params[:servidor_id])

    if @componente.save
      render json:@componente, status:200
    else
      render json:{error: "No se pudo ingresar"}
    end
  end

  def update
    @componente = Componente.find(params[:id])

    if @componente
      @componente.update(nroCPU: params[:nroCPU], memoria: params[:memoria], almacenamiento: params[:almacenamiento], servidor_id: params[:servidor_id])
      render json: {message: "Actualizado exitosamente"}
    else
      render json:{error: "No se pudo actualizar"}
    end
  end

  def destroy
    @componente = Componente.find(params[:id])
    if @componente
      @componente.destroy
      render json: {message: "Eliminado exitosamente"}
    else
      render json: { error: 'No se pudo eliminar el componente', errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
    def component_params
      params.require(:componente).permit(:nroCPU, :memoria, :almacenamiento, :servidor_id)
    end
end
