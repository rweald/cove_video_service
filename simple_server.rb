require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'yajl/json_gem'
require 'erb'
require 'openssl'
require 'dalli'

set :views, File.join(File.dirname(__FILE__), "templates")

DB = Dalli::Client.new(['localhost:11211'], :expires_in => 3600)

# This is simply a demo url that shows off how the page will work
# It will soon be removed and be a documentation page
get '/' do
  @name = "videoplayback.webm"
  @name = params[:name] + ".webm" if params[:name]
  erb :index
end

# Method that will return a token for the given video
# requires the name or identifier of the video in the parameter
# video
# E.X// '/token?video=demo.webm'
get '/token' do
  unless params[:video]
    response.status = 400
    content_type :json
    return {"status" => "failed", "notice" => "No video specified you must specify a video"}.to_json
  end
  token = generate_token(params[:video])
  {"status" => "success", 'token' => token}.to_json
end

# Executes a sendfile with the video if the given token is valid.
# Require both token and video as parameters
# E.X// '/<token>/<filename>.<extension>
get '/:token/:name.:extension' do
  unless valid_token(params[:token], "#{params[:name]}.#{params[:extension]}")
    response.status = 403
    return {"status" => "failed", "notice" => "Invalid token"}.to_json
  end
  send_file File.join(File.dirname(__FILE__), "videos", "#{params[:name]}.#{params[:extension]}")
end


get '/test_video.m4v' do
  send_file File.join(File.dirname(__FILE__), 'videos', 'test.m4v')
end
# Generate the secure random token and store it in the db 
# so we can check for token validity later. 
def generate_token(video_name)
  token = OpenSSL::BN.rand(2*16).to_s(16)
  begin
    DB.set(token, video_name)
  rescue
    raise "problem persisting token to memcache"
  end
  return token
end

#queries the db to determin whether the given token is valid 
#and matches the given video name
def valid_token(token, video_name)
  return false unless token && video_name

  value = DB.get(token)
  if value && value == video_name
    return true 
  else
    return false
  end
end
