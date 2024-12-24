class Device
  include ActiveModel::API
  include ActiveModel::Attributes


  attribute :id, :string
  attribute :readings, array: true, default: []

  validate :validate_input

  def initialize(attributes)
    super(attributes)
    sanitize!
  end

  def sanitize!
    remove_duplicates!(self.readings)
    self.readings.sort_by!(&:timestamp)
  end

  private

  def validate_input
    uuid_regex_pattern = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
    self.errors.add(:malformed_input, "Bad UUID") unless uuid_regex_pattern.match?(attributes["id"])

    self.errors.add(:malformed_input, "No Readings") if attributes["readings"].empty?
  end

  #this removes all but the first instance of any duplicate timestamped readings from either the current request
  # or previously cached requests
  def remove_duplicates!(new_readings)
    duplicates = track_duplicates(new_readings)
    duplicates.each do |key, value|
      first_occurance_index = readings.map(&:timestamp).index(key)
      first_occurance = readings[first_occurance_index]
      readings.reject! { |reading| reading.timestamp == key }
      readings.append(first_occurance)
    end
  end

  def track_duplicates(new_readings)
    counts = Hash.new(0)
    readings = self.readings.concat(new_readings)
    readings.each { |reading| counts[reading.timestamp.to_s] += 1 }
    counts.select { |key, value| value > 1 }
  end
end
