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
        resp['status'].should == "No video specified you must specify a video"
      end
    end   
  end
end
