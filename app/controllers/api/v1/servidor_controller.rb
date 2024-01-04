class Api::V1::ServidorController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :authenticate_dba!, only: [:update, :create, :destroy]

  def index
    @servidor = Servidor.all()
  
    if params[:nombre]
      @servidor = @servidor.where("nombre LIKE ?", "%#{params[:nombre]}%")
    end

    page = params[:page] || 1
    per_page = params[:limit] || 10

    @servidor = @servidor.page(page).per(per_page)

    render json: {
      servidores: @servidor,
      total_count: @servidor.total_count
    }
  end

  def show
    @servidor = Servidor.find(params[:id])
    if @servidor
      render json:@servidor, status: 200
    else
      render json: {error: "Servidor no encontrado"}
    end
  end

  def new
    @servidor = Servidor.new
  end

  def create
    @servidor = Servidor.new(
      nombre: server_params[:nombre], 
      direccionIP: server_params[:direccionIP], 
      SO: server_params[:SO],
      motorBase: server_params[:motorBase])

    if @servidor.save
      render json:@servidor, status:200
    else
      render json:{error: "No se pudo ingresar"}
    end
  end

  def update
    @servidor = Servidor.find(params[:id])

    if @servidor
      @servidor.update(nombre: params[:nombre], direccionIP: params[:direccionIP], SO: params[:SO], motorBase: params[:motorBase])
      render json: {message: "Actualizado exitosamente"}
    else
      render json:{error: "No se pudo actualizar"}
    end
  end

  def destroy
    @servidor = Servidor.find(params[:id])
    if @servidor
      @servidor.destroy
      render json: {message: "Eliminado exitosamente"}
    else
      render json: { error: 'No se pudo eliminar el servidor', errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
    def server_params
      params.require(:servidor).permit(:nombre, :direccionIP, :SO, :motorBase)
    end

    
end
