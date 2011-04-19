require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'yajl/json_gem'
require 'erb'

set :views, File.join(File.dirname(__FILE__), "templates")

get '/' do
  @name = "videoplayback.webm"
  @name = params[:name] + ".webm" if params[:name]
  erb :index
end

get '/token' do
  unless params[:video]
    response.status = 400
    content_type :json
    return {"status" => "No video specified you must specify a video"}.to_json
  end
end

get '/video' do
  send_file File.join(File.dirname(__FILE__), "videos", params[:name])
end
