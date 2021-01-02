FactoryBot.define do
  factory :event do
    association :histories, factory: :hisory

    object_id 1
    object_type 'Test'
  end
end
