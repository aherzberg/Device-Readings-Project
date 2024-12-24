require 'rails_helper'

RSpec.describe "Reading Latest", type: :request do
  describe "POST devices/:id/readings/latest" do
    context 'when device readings are posted out of order' do
      it 'responds with latest timestamp' do
        Rails.cache.clear

        id = '36d5658a-6908-479e-887e-a949ec199272'
        post device_readings_path(id: id, readings: [ { timestamp: "2022-09-29T16:08:15+01:00", count: 2 }, { timestamp: "2021-09-29T16:08:15+01:00", count: 2 } ])

        get device_readings_latest_path(id: id)

        expect(response.parsed_body['latest_timestamp']).to eq('2022-09-29T16:08:15.000+01:00')
      end
    end
  end
end
