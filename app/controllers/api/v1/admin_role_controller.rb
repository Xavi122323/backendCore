class Api::V1::AdminRoleController < ApplicationController

  before_action :authenticate_admin!, only: [:index, :update]

  def index
    @admin_role = User.all()
    render json: @admin_role.as_json(only: [:id, :email, :role]), status: 200
  end

  def show
    @admin_role = User.find(params[:id])
    if @admin_role
      render json: @admin_role, status: 200
    else
      render json: {error: "Usuario no encontrado"}, status: 404
    end
  end

  def new
    @admin_role = User.new
  end

  def update
    @admin_role = User.find(params[:id])
    if @admin_role
      @admin_role.update(role: params[:role])
      render json: {message: "Actualizado exitosamente"}
    else
      render json: {error: "No se pudo actualizar"}
    end
  end

  def destroy
    @admin_role = User.find(params[:id])
    if @admin_role
      @admin_role.destroy
      render json: {message: "Eliminado exitosamente"}
    else
      render json: { error: 'Unable to delete user', errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

end
