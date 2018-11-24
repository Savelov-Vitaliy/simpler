Simpler.application.routes do
  get '/tests',     'tests#index'
  get '/tests/:id', 'tests#show'
  get '/tests/:test_title/question/:id', 'tests#index'
  post '/tests', 'tests#create'
  post '/tests/:var_route_one/question/:var_route_two/author/:var_route_three', 'tests#index'
  get '/list/:year/:number', 'tests#list'
end
