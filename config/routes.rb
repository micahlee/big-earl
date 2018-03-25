Rails.application.routes.draw do
  post '/', to: 'short_link#create', as: :create

  get '/:code', to: 'short_link#show', as: :short_link
  get '/:code/preview', to: 'short_link#preview', as: :short_link_preview
  get '/:code/thumbnail', to: 'short_link#thumbnail', as: :short_link_thumbnail

  root 'short_link#new'
end
