class FeatureCollectionsController < ApplicationController

  # GET /areas
  def areas
    @feature_collection = FeatureCollection.last

    render json: @feature_collection.areas, status: :ok
  end

  # GET /feature_collections/1
  def show
    @feature_collection = FeatureCollection.find(params[:id])
    render json: @feature_collection
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: 'Not found' }, status: :unprocessable_entity
  end

  # POST /feature_collections
  def create
    FeatureCollection.create(areas: feature_collection_params)
    render json: { message: "Polygon created" }, status: :created
  rescue GeojsonError::MissingInformationError, GeojsonError::InvalidParametersError,
         GeojsonError::InvalidCoordinatesError, GeojsonError::NotEnoughCoordinatesError,
         GeojsonError::NotPolygonError, GeojsonError::OpenCoordinatesError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private
    # Only allow a trusted parameter "white list" through.
    def feature_collection_params
      params.require(:feature_collection)
    end
end
