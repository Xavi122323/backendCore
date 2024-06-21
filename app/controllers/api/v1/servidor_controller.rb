class Api::V1::ServidorController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @servidor = Servidor.all

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
      render json: @servidor, status: 200
    else
      render json: { error: "Servidor no encontrado" }, status: 404
    end
  end

  def new
    @servidor = Servidor.new
  end

  def create
    @servidor = Servidor.new(server_params)

    if @servidor.save
      render json: @servidor, status: 200
    else
      render json: { error: "No se pudo ingresar" }, status: 422
    end
  end

  def update
    @servidor = Servidor.find(params[:id])

    if @servidor.update(server_params)
      render json: { message: "Actualizado exitosamente" }, status: 200
    else
      render json: { error: "No se pudo actualizar" }, status: 422
    end
  end

  def destroy
    @servidor = Servidor.find(params[:id])
    if @servidor
      @servidor.destroy
      render json: { message: "Eliminado exitosamente" }, status: 200
    else
      render json: { error: 'No se pudo eliminar el servidor' }, status: :unprocessable_entity
    end
  end

  private

  def server_params
    params.require(:servidor).permit(:nombre, :direccionIP, :SO, :motorBase)
  end

  # Overriding the process_token method to disable SSL verification
  def process_token
    if request.headers['Authorization'].present?
      begin
        token = request.headers['Authorization'].split(' ')[1]
        jwks_url = "https://cloak.mindsoftdev.com:8443/realms/external/protocol/openid-connect/certs"
        jwks = HTTP.get(jwks_url, ssl_context: OpenSSL::SSL::SSLContext.new.tap { |ctx| ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE }).parse(:json)
        decoded_token = JWT.decode(token, nil, true, { algorithms: ['RS256'], jwks: jwks })[0]

        @current_user = User.find_or_create_from_keycloak(decoded_token)
      rescue JWT::ExpiredSignature
        head :unauthorized and return
      rescue JWT::VerificationError, JWT::DecodeError => e
        render json: { error: "Invalid token: #{e.message}" }, status: :unauthorized and return
      end
    else
      head :unauthorized
    end
  end
end
