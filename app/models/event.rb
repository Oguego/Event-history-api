class Event < ApplicationRecord
  has_many :histories

  validates :object_type, :object_id, presence: true

  validates :object_id, uniqueness: true
end
