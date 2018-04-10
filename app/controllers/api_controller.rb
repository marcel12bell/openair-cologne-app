class ApiController < ActionController::Base
  layout 'blank'

  def show
    @sensors = Sensor.joins(:locations).group(:id)
    @locations = []
    @sensors.each do |s|
      @locations << { type: "Feature",
      geometry: {type: "Point", "coordinates": [s.locations.last.longitude.to_f + 0.00004,s.locations.last.latitude.to_f + 0.00003]},
      properties: {sensor_id: s.node_id, data: []}
      }
    end
    respond_to do |format|
      format.json { render :json => { type: "FeatureCollection",
      features: @locations
      }, :callback => params['callback'] }
    end
  end
end