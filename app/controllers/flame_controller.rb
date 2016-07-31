class FlameController < ApplicationController

  def set_level
    if params[:level].present?
      fire_level = params[:level].to_f
    else
      fire_level = 0.01
    end

    SizzleRig::Arduino::Serial.instance.rotate(fire_level)
  end

end
