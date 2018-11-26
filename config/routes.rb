Rails.application.routes.draw do
	root to: 'prepare_matrix#index'
	get 'prepare_matrix/generate_matrix', to: 'prepare_matrix#generate_matrix'
	get 'prepare_matrix/update_matrix', to: 'prepare_matrix#update_matrix'
	#get '/display_board', to: 'prepare_matrix#display_board'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
