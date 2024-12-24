class ReadingLatestController < ActionController::API
  def show
    device = Rails.cache.read(id)
    if device.nil?
      render json: {}, status: 404
    else
      render json: { latest_timestamp: device.readings.last.timestamp }
    end
  end

  private

  def id
    params.require(:id)
  end
end
