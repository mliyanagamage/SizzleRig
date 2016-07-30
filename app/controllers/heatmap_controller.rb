class HeatmapController < ApplicationController

  def index
  end

  def data
    start_time = Date.parse(params[:date]).beginning_of_week.to_time
    end_date = start_time.end_of_week

    

  end
end
