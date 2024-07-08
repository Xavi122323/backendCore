class Api::V1::ServidorController < ApplicationController
  before_action :authenticate_user!

  def index
    @servidores = Servidor.all
  
    if params[:nombre]
      @servidores = @servidores.where("nombre LIKE ?", "%#{params[:nombre]}%")
    end
  
    page = params[:page] || 1
    per_page = params[:limit] || 10
  
    @servidores = @servidores.page(page).per(per_page)
  
    decrypted_servidores = @servidores.map do |servidor|
      {
        nombre: KmsService.decrypt(servidor.nombre),
        direccionIP: KmsService.decrypt(servidor.direccionIP),
        SO: KmsService.decrypt(servidor.SO),
        motorBase: KmsService.decrypt(servidor.motorBase)
      }
    end
  
    render json: {
      servidores: decrypted_servidores,
      total_count: @servidores.total_count
    }
  end

  def show
    @servidor = Servidor.find(params[:id])
    if @servidor
      decrypted_data = {
        nombre: KmsService.decrypt(@servidor.nombre),
        direccionIP: KmsService.decrypt(@servidor.direccionIP),
        SO: KmsService.decrypt(@servidor.SO),
        motorBase: KmsService.decrypt(@servidor.motorBase)
      }
      render json: decrypted_data, status: 200
    else
      render json: {error: "Servidor no encontrado"}
    end
  end

  def new
    @servidor = Servidor.new
  end

  def create
    encrypted_params = {
      nombre: KmsService.encrypt(server_params[:nombre]),
      direccionIP: KmsService.encrypt(server_params[:direccionIP]),
      SO: KmsService.encrypt(server_params[:SO]),
      motorBase: KmsService.encrypt(server_params[:motorBase])
    }
    @servidor = Servidor.new(encrypted_params)

    if @servidor.save
      render json: @servidor, status: 200
    else
      render json: {error: "No se pudo ingresar"}
    end
  end

  def update
    @servidor = Servidor.find(params[:id])
    encrypted_params = {
      nombre: KmsService.encrypt(server_params[:nombre]),
      direccionIP: KmsService.encrypt(server_params[:direccionIP]),
      SO: KmsService.encrypt(server_params[:SO]),
      motorBase: KmsService.encrypt(server_params[:motorBase])
    }

    if @servidor.update(encrypted_params)
      render json: {message: "Actualizado exitosamente"}
    else
      render json: {error: "No se pudo actualizar"}
    end
  end

  def destroy
    @servidor = Servidor.find(params[:id])
    if @servidor.destroy
      render json: {message: "Eliminado exitosamente"}
    else
      render json: {error: 'No se pudo eliminar el servidor', errors: @servidor.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def show_encrypted
    @servidores = Servidor.all
  
    if params[:nombre]
      @servidores = @servidores.where("nombre LIKE ?", "%#{params[:nombre]}%")
    end
  
    page = params[:page] || 1
    per_page = params[:limit] || 10
  
    @servidores = @servidores.page(page).per(per_page)
  
    encrypted_servidores = @servidores.map do |servidor|
      {
        nombre: servidor.nombre,
        direccionIP: servidor.direccionIP,
        SO: servidor.SO,
        motorBase: servidor.motorBase
      }
    end
  
    render json: {
      servidores: encrypted_servidores,
      total_count: @servidores.total_count
    }
  end

  private

  def server_params
    params.require(:servidor).permit(:nombre, :direccionIP, :SO, :motorBase)
  end
end
