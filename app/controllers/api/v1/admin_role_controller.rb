class Api::V1::AdminRoleController < ApplicationController
  def index
    @admin_role = AdminRole.all
    render json: @admin_role, status : 200
  end

  def show
    @admin_role = AdminRole.find(params[:id])
    if @admin_role
      render json: @admin_role, status : 200
    else
      render json: {error: "Usuario no encontrado"}, status : 404
    end
  end

  def new
    @admin_role = AdminRole.new
  end

  def update
    @admin_role = AdminRole.find(params[:id])
    if @admin_role
      @admin_role.update(role: params[:role])
      render json: {message: "Actualizado exitosamente"}
    else
      render json: {error: "No se pudo actualizar"}
    end
  end
  
end
