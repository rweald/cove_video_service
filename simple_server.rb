require 'sinatra'
require 'yajl/json_gem'
require 'erb'

set :views, File.join(File.dirname(__FILE__), "templates")

get '/' do
  @name = "videoplayback.webm"
  @name = params[:name] + ".webm" if params[:name]
  erb :index
end

get '/video' do
  send_file File.join(File.dirname(__FILE__), "videos", params[:name])
end
