
class Reading
  include ActiveModel::API
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :timestamp, :datetime
  attribute :count, :integer
end
