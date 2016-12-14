require 'sinatra/base'
require 'sinatra/reloader'

class ElevationProfiler < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    haml :home
  end

  get '/calculate_route' do
    content_type :json

    { r: 4 }.to_json
  end
end
