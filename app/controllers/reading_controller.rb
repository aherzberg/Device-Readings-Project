class ReadingController < ActionController::API
  def update
    device = Rails.cache.read(id)

    device = Device.new(id: id, readings: Array.wrap(device&.readings).concat(parsed_readings))

    if device.valid?
      Rails.cache.write(device.id, device)

      head :no_content
    else
      render json: { errors: device.errors }, status: 422
    end
  end

  private

  def id
    params.require(:id)
  end

  def readings
    params.require(:readings)
    readings = params.permit(readings: %i[timestamp count])[:readings]
    readings.delete_if { |reading| reading.empty? }
  end

  def parsed_readings
    readings.map do |reading|
      Reading.new(
        timestamp: DateTime.parse(reading[:timestamp]),
        count: reading[:count].to_i,
        )
    end
  end
end
