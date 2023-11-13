class Api::V1::ServidorController < ApplicationController
  def index
    @servidor = Servidor.all()
    render json:@servidor, status: 200
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
      render json: "Actualizado exitosamente"
    else
      render json:{error: "No se pudo actualizar"}
    end
  end

  def destroy
    @servidor = Servidor.find(params[:id])
    if @servidor
      @servidor.destroy
      render json: "Eliminado exitosamente"
    end
  end

  private
    def server_params
      params.require(:servidor).permit(:nombre, :direccionIP, :SO, :motorBase)
    end
end
