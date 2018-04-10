class VisualisationController < ApplicationController
  def index

  end
  def show
    #@sensor = current_user.sensors.find_by_node_id(params[:id])
    @sensors = Sensor.joins(:user).all
  end
end
