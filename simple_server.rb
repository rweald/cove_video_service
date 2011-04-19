require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'yajl/json_gem'
require 'erb'
require 'openssl'

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
    return {"status" => "failed", "notice" => "No video specified you must specify a video"}.to_json
  end
  token = generate_token
  {"status" => "success", 'token' => token}.to_json
end

get '/video' do
  send_file File.join(File.dirname(__FILE__), "videos", params[:name])
end

def ensure_video_param
end

def generate_token
  OpenSSL::BN.rand(2*16).to_s(16)
end
