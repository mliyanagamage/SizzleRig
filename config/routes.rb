Rails.application.routes.draw do
  get '/' => 'home#index'
  get '/heatmap' => 'heatmap#index'
  get '/heatmap/data' => 'heatmap#data'
  post '/fire' => 'fire#set_level'

  get '/act' => 'act_fire_status#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
