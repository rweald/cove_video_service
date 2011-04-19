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
end
