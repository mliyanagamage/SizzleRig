class HeatmapController < ApplicationController

  def index
  end

  def data
    if params[:date].present?
      start_time = Date.parse(params[:date]).beginning_of_day.to_time
    else
      start_time = Time.now.beginning_of_day
    end
    end_time = start_time.end_of_day

    @data = SentinelDatum.where(datetime: start_time..end_time).select(:latitude, :longitude, :power, :id)

    render json: { data: @data }, status: 200
  end
end
