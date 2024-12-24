class ReadingSumController < ActionController::API
  def show
    device = Rails.cache.read(id)
    if device.nil?
      render json: {}, status: 404
    else
      render json: { cumulative_count: device.readings.map(&:count).sum }
    end
  end

  private

  def id
    params.require(:id)
  end
end
