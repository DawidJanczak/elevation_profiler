require 'sinatra/base'

class ElevationProfiler < Sinatra::Base
  get '/' do
    haml :home
  end
end
