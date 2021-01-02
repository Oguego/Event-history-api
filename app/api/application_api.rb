class ApplicationApi < Grape::API
  mount V1::Events
end