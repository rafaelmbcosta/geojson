class CoordinatesController < ApplicationController
  # GET /inside
  def inside
    inside = Coordinate.inside(inside_params)
    render json: { inside: inside }
  rescue GeojsonError::MissingInformationError,
         GeojsonError::InvalidCoordinatesError,
         GeojsonError::NotPointError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def create
    coordinate = Coordinate.create(location_params)
    render json: { id: coordinate.id }, status: :created
  rescue GeojsonError::InvalidParametersError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def show
    @coordinate = Coordinate.find(params[:id])
    if @coordinate.async_errors.blank? 
      render json: @coordinate
    else
      render json: { error: @coordinate.async_errors }
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: 'Coordinate not found' }, status: :unprocessable_entity
  end

  private

  def inside_params
    params.require(:point).permit(:type, :geometry => [:type, :coordinates => []], :properties => [:name])
  end

  def location_params
    params.require(:location).permit(:query)
  end
end
