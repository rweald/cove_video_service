require 'spec_helper'

describe "SimpleServer" do
  
  def app
    Sinatra::Application
  end
  
  describe "GET 'token'" do
    context "no video specified" do
      before(:each) do
        get '/token'
      end
      it 'should return http 400 code' do
        last_response.status.should == 400
      end
      it "should send failure message" do
        resp = JSON.parse(last_response.body)
        resp['status'].should == "failed"
      end

      it "should send a notice that specifies the problem" do
        resp = JSON.parse(last_response.body)
        resp['notice'].should == "No video specified you must specify a video"
      end
    end   

    context "video specified" do
      before(:each) do
        resp = get '/token', :video => "videoplayback.webm"
        @resp = JSON.parse(resp.body)
      end
      it "should return status 200" do
        last_response.status.should == 200
      end
      it "should send success message in json" do
        @resp['status'].should == 'success'
      end
      it "should return a token in the json" do
        @resp['token'].should be
      end
    end
  end

  describe "GET 'video'" do
    def get_token(name)
      resp = get 'token', :video => name
      resp = JSON.parse(resp.body)
      resp['token']
    end
    context 'invalid token' do
      before(:each) do
        get '/video/something.m4v'
      end
      it 'should respond with 403' do
        last_response.status.should == 403
      end
      it "should describe the reason in the json" do
        resp = JSON.parse(last_response.body)
        resp['notice'].should == "Invalid token"
      end
    end
    context 'valid token' do
      it "should respond with 200 if video found" do
        token = get_token("videoplayback.webm")
        puts token
        puts "/#{token}/videoplayback.webm"
        get "#{token}/videoplayback.webm"
        last_response.status.should == 200
      end
      it 'should return 404 if video not found' do 
        token = get_token("helloworld.m4v")
        get "#{token}/wierd_File_name.m4v"
        last_response.status.should == 404
      end
    end
  end
end
