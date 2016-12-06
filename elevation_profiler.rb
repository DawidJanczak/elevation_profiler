require 'sinatra/base'

class ElevationProfiler < Sinatra::Base
  get '/' do
    'Elevation Profiler'
  end
end
