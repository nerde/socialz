Rails.application.routes.draw do
  root to: 'home#index', defaults: { format: :json }
end
