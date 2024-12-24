require 'rails_helper'

RSpec.describe "Readings", type: :request do
  describe "POST devices/:id/readings" do
    before(:each) { Rails.cache.clear }

    let(:id) {'36d5658a-6908-479e-887e-a949ec199272'}

    context 'when readings is malformed' do
      it 'responds with unprocessable entity error' do
        post device_readings_path(id: id, readings: [ test: 'test' ])

        expect(response.status).to eq(422)
        expect(response.parsed_body).to eq({ "errors"=>{ "malformed_input"=>[ "No Readings" ] } })
        expect(Rails.cache.read(id)).to eq(nil)
      end
    end

    context 'when id is malformed' do
      it 'responds with unprocessable entity error' do
        bad_id = '1-2-3-4-5'

        post device_readings_path(id: bad_id, readings: [ timestamp: "2021-09-29T16:08:15+01:00", count: 2 ])
        expect(response.status).to eq(422)
        expect(response.parsed_body).to eq({ "errors"=>{ "malformed_input"=>[ "Bad UUID" ] } })
        expect(Rails.cache.read(id)).to eq(nil)
      end
    end

    context 'when device cache does not already exist' do
      it 'adds readings to cache' do
        post device_readings_path(id: id, readings: [ timestamp: "2021-09-29T16:08:15+01:00", count: 2 ])

        expect(response.status).to eq(204)
        expect(Rails.cache.read(id).class).to eq(Device)
      end
    end

    context 'when device cache already exist and a new reading is sent' do
      it 'reading is added to cache' do
        post device_readings_path(id: id, readings: [ timestamp: "2021-09-29T16:08:15+01:00", count: 1 ])

        post device_readings_path(id: id, readings: [ timestamp: "2022-09-29T16:08:15+01:00", count: 5 ])

        expect(response.status).to eq(204)
        expect(Rails.cache.read(id).readings.count).to eq(2)
      end
    end

    context 'when there is a duplicate timestamp' do
      it 'ignores the duplicate reading and keeps the original' do
        post device_readings_path(id: id, readings: [ timestamp: "2021-09-29T16:08:15+01:00", count: 3 ])
        post device_readings_path(id: id, readings: [ timestamp: "2021-09-29T16:08:15+01:00", count: 5 ])

        expect(response.status).to eq(204)
        expect(Rails.cache.read(id).readings.count).to eq(1)
        expect(Rails.cache.read(id).readings[0].count).to eq(3)
      end
    end
  end
end
