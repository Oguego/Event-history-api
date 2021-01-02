class History < ApplicationRecord
  belongs_to :event
  serialize :data_before, Hash
  serialize :data_after, Hash

  validates :when, :user, :event_type, presence: true
end
