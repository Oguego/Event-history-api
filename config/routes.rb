Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount ApplicationApi, at: '/'

  root to: 'welcome#home'

  get 'history', to: 'history#index', as: 'events_history'

  get 'history/:event_id', to: 'history#show', as: 'show_history'

end
