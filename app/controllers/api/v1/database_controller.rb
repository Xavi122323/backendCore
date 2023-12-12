class Api::V1::DatabaseController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :authenticate_dba!, only: [:update, :create, :destroy]

  def index
    @database = Database.includes(:servidor).all()
    #render json:@database.as_json(include: :servidor), status: 200
    render json: @database.map { |database|
      database.as_json.merge({ server_name: database.servidor.nombre })
    }
  end

  def show
    @database = Database.find(params[:id])
    if @database
      render json:@database, status: 200
    else
      render json: {error: "Database no encontrado"}
    end
  end

  def new
    @database = Database.new
  end

  def create
    @database = Database.new(
      nombre: database_params[:nombre], 
      transaccionesDia: database_params[:transaccionesDia], 
      transaccionesMes: database_params[:transaccionesMes],
      servidor_id: database_params[:servidor_id])

    if @database.save
      render json:@database, status:200
    else
      render json:{error: "No se pudo ingresar"}
    end
  end

  def update
    @database = Database.find(params[:id])

    if @database
      @database.update(nombre: params[:nombre], transaccionesDia: params[:transaccionesDia], almacenatransaccionesMesmiento: params[:transaccionesMes], servidor_id: params[:servidor_id])
      render json: {message: "Actualizado exitosamente"}
    else
      render json:{error: "No se pudo actualizar"}
    end
  end

  def destroy
    @database = Database.find(params[:id])
    if @database
      @database.destroy
      render json: {message: "Eliminado exitosamente"}
    else
      render json: { error: 'No se pudo eliminar el Database', errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
    def database_params
      params.require(:database).permit(:nombre, :transaccionesDia, :transaccionesMes, :servidor_id)
    end

end
