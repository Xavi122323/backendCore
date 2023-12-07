class Api::V1::ComponenteController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :authenticate_dba!, only: [:update, :create, :destroy]

  def index
    @componente = Componente.all()
    render json:@componente, status: 200
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
      nombre: component_params[:nroCPU], 
      direccionIP: component_params[:memoria], 
      SO: component_params[:almacenamiento],
      motorBase: component_params[:server_id])

    if @componente.save
      render json:@componente, status:200
    else
      render json:{error: "No se pudo ingresar"}
    end
  end

  def update
    @componente = Componente.find(params[:id])

    if @componente
      @componente.update(nroCPU: params[:nroCPU], memoria: params[:memoria], almacenamiento: params[:almacenamiento], server_id: params[:server_id])
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
      params.require(:componente).permit(:nroCPU, :memoria, :almacenamiento, :server_id)
    end
end
