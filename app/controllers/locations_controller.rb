class LocationsController < ApplicationController
  before_action :set_location, only: [:index, :show, :edit, :update, :destroy]

  # GET /locations
  # GET /locations.json
  def index
    redirect_to sensors_path if params[:sensor_id].blank?
    @locations = Location.joins(:sensor).where({locations: {sensor_id: params[:sensor_id]}})
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
  end

  # GET /locations/new
  def new
    @location = Location.new
    @location.sensor_id = params[:sensor_id]
  end

  # GET /locations/1/edit
  def edit
  end

  # POST /locations
  # POST /locations.json
  def create
    @location = Location.new(location_params)
    respond_to do |format|
      if @location.save
        format.html { redirect_to locations_path(sensor_id: @location.sensor_id), notice: 'Der Ort wurde angelegt.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /locations/1
  # PATCH/PUT /locations/1.json
  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to locations_path(sensor_id: @location.sensor_id), notice: 'Der Ort wurde gespeichert' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location.destroy
    respond_to do |format|
      format.html { redirect_to locations_url, notice: 'Location was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @sensors = current_user.sensors
      @location = Location.joins(:sensor).where({locations: {id: params[:id]} }).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
      params.require(:location).permit(:street, :zip, :longitude, :latitude, :altitude, :face_street, :quiet_condition, :direction,:sensor_id)
    end
end

