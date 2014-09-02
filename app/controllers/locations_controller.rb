class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]
  # GET /locations
  # GET /locations.json
  def index
    # perdorm a search on locations with received params
    @locations = Location.search(params[:search])
    # generate markes for resulting location
    set_markers(@locations)
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
    set_markers(@location)
  end

  # GET /locations/new
  def new
    @location = Location.new
    @location.latitude = params[:latitude]
    @location.longitude = params[:longitude]
    set_markers(@location)
  end

  # GET /locations/1/edit
  def edit
    set_markers(@location)
  end

  # POST /locations
  # POST /locations.json
  def create
    @location = Location.new(location_params)

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: 'Location was successfully created.' }
        format.json { render :show, status: :created, location: @location }
      else
        format.html { render :new }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locations/1
  # PATCH/PUT /locations/1.json
  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location.destroy
    respond_to do |format|
      format.html { redirect_to locations_url, notice: 'Location was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
      params.require(:location).permit(:latitude, :longitude, :address, :title)
    end

    # Receives a hash with loc data, extracts latitude and longitude
    # and generates a marker hash for use with gmaps4rails
    def set_markers(loc_data)
      @hash = Gmaps4rails.build_markers(loc_data) do |location, marker|
        marker.lat location.latitude
        marker.lng location.longitude
        marker.infowindow location.title
    end
  end
end
