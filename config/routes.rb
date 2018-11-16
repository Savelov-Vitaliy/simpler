Simpler.application.routes do
  get '/tests',     'tests#index'
  get '/tests/:id', 'tests#show'
  get '/list',      'tests#list'
  get '/list/:id',  'tests#list'
  post '/tests',    'tests#create'
end
