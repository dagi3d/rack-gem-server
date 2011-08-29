require File.expand_path('../spec_helper', __FILE__)

describe GemServer do
  
  
  def app
    GemServer.new
  end
  
  let(:local_file) { Rack::Test::UploadedFile.new(File.expand_path('../foo.gem', __FILE__)) }
  
  it "should not respond to post /push when no file is given" do
    post "/push"
    last_response.should_not be_ok
  end
  
  it "should respond to post /push when a gile is given" do
    post "/push", :file => local_file
    last_response.should be_ok
  end
  
  it "should not respond to get /push" do
    get "/push"
    last_response.should_not be_ok
  end
  
  it "should upload the gem to public/gems directory" do
    uploaded_file = File.join(APP_ROOT, 'public', 'gems', 'foo.gem')
    FileUtils.rm(uploaded_file) if File.exists?(uploaded_file)
    post "/push", :file => local_file
    File.exists?(uploaded_file).should be_true
  end
  
end