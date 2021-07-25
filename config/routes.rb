Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "upload_files#index"
  resources :upload_files, :only => [:index, :create, :destroy]
end
