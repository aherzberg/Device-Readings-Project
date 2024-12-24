require 'rails_helper'

RSpec.describe Device, type: :model do
  let(:id) { '36d5658a-6908-479e-887e-a949ec199272' }

  context 'when device is created' do
    it 'returns device object' do
      device = Device.new(
        id: id,
        readings: [
          Reading.new(
            timestamp: DateTime.parse('2021-09-29T16:08:15+01:00'),
            count: 3,
            )
        ]
      )
      expect(device.as_json).to eq({ "attributes"=>{ "id"=>"36d5658a-6908-479e-887e-a949ec199272", "readings"=>[ { "attributes"=>{ "timestamp"=>"2021-09-29T16:08:15.000+01:00", "count"=>3 } } ] } })
    end
  end

  context 'when device is updated' do
    let (:new_reading) { [
      Reading.new(
        timestamp: DateTime.parse('2021-09-29T16:08:15+01:00'),
        count: 5,
        )
    ]}

    context 'when new readings contain 1 duplicate' do
      let (:new_readings) { [
        Reading.new(
          timestamp: DateTime.parse('2023-09-29T16:08:15+01:00'),
          count: 5,
          ),
        Reading.new(
          timestamp: DateTime.parse('2023-09-29T16:08:15+01:00'),
          count: 7,
          )
      ]}
      it 'prevents duplicates from being added to Device' do
        device = Device.new(id: id, readings: new_readings)
        expect(device.readings.count).to eq(1)
        expect(device.readings.first.count).to eq(5)
      end
    end

    context 'when new readings contain multiple duplicates' do
      let (:new_duplicate_readings) { [
        Reading.new(
          timestamp: DateTime.parse('2023-09-29T16:08:15+01:00'),
          count: 5,
          ),
        Reading.new(
          timestamp: DateTime.parse('2023-09-29T16:08:15+01:00'),
          count: 7,
          ),
        Reading.new(
          timestamp: DateTime.parse('2023-09-29T16:08:15+01:00'),
          count: 9,
          )
      ]}
      it 'prevents duplicates from being added to Device' do
        device = Device.new(id: id, readings: new_duplicate_readings)
        expect(device.readings.count).to eq(1)
        expect(device.readings.first.count).to eq(5)
      end
    end

    context 'when new readings come out of order' do
      let(:out_of_order_readings) { [
        Reading.new(
          timestamp: DateTime.parse('2023-09-29T16:08:15+01:00'),
          count: 5,
          ),
        Reading.new(
          timestamp: DateTime.parse('2022-09-29T16:08:15+01:00'),
          count: 7,
          ),
        Reading.new(
          timestamp: DateTime.parse('2027-09-29T16:08:15+01:00'),
          count: 7,
          )
      ]}
      it 'prevents duplicates from being added to Device' do
        device = Device.new(id: id, readings: out_of_order_readings)
        expect(device.readings[0].timestamp.to_s).to eq('2022-09-29T16:08:15+01:00')
        expect(device.readings[1].timestamp.to_s).to eq('2023-09-29T16:08:15+01:00')
        expect(device.readings[2].timestamp.to_s).to eq('2027-09-29T16:08:15+01:00')
      end
    end
  end
end
