class Api::V1::DatabaseController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :authenticate_dba!, only: [:update, :create, :destroy]

  def index
    @database = Database.includes(:servidor).all()
    
    if params[:servidor]
      @database = @database.joins(:servidor).where("servidors.nombre LIKE ?", "%#{params[:servidor]}%")
    end

    if params[:nombre]
      @database = @database.where("databases.nombre LIKE ?", "%#{params[:nombre]}%")
    end

    render json: @database.map { |database|
      database.as_json.merge({ server_name: database.servidor.nombre })
    }
  end

  def show
    @database = Database.find(params[:id])
    if @database
      render json:@database, status: 200
    else
      render json: {error: "Base no encontrada"}
    end
  end

  def new
    @database = Database.new
  end

  def create
    @database = Database.new(
      nombre: database_params[:nombre], 
      transacciones: database_params[:transacciones], 
      fechaTransaccion: database_params[:fechaTransaccion],
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
      @database.update(nombre: params[:nombre], transacciones: params[:transacciones], fechaTransaccion: params[:fechaTransaccion], servidor_id: params[:servidor_id])
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
      render json: { error: 'No se pudo eliminar la Base', errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
    def database_params
      params.require(:database).permit(:nombre, :transacciones, :fechaTransaccion, :servidor_id)
    end

end
