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

  private

  def inside_params
    params.require(:point).permit(:type, :geometry => [:type, :coordinates => []], :properties => [:name])
  end

end
