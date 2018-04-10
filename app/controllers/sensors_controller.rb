class SensorsController < ApplicationController
  before_action :authenticate_user!

  def index
    @sensors = current_user.sensors
  end

  def create
    Sensor.where(user_id: nil).last.update_attributes(user_id: current_user.id)
    redirect_to sensors_path()
  end

  def show
    @sensor = current_user.sensors.find_by_node_id(params[:id])
  end

  def edit
    @sensor = current_user.sensors.find_by_node_id(params[:id])
  end

  def visualisation
    #@sensor = current_user.sensors.find_by_node_id(params[:id])
    @sensors = Sensor.joins(:user).all
  end
end
