require File.expand_path('../spec_helper', __FILE__)

describe GemServer do
  
  def app
    GemServer.new
  end
  
  context "get /" do
    it "should list the installed gems on /" do
      get "/"
      
    end
  end
  
  context "post /push" do
    let(:local_file) { Rack::Test::UploadedFile.new(File.expand_path('../foo-0.0.1.gem', __FILE__)) }
    let(:gem_index) { Gem::Indexer.new("#{APP_ROOT}/public") }
  
    
    before do
      Gem::Indexer.stub(:new).and_return(gem_index)
      gem_index.stub(:generate_index).and_return(true)
    end
    
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
      uploaded_file = File.join(APP_ROOT, 'public', 'gems', 'foo-0.0.1.gem')
      FileUtils.rm(uploaded_file) if File.exists?(uploaded_file)
      post "/push", :file => local_file
      File.exists?(uploaded_file).should be_true
    end
  
    it "should generate the index on public/gems" do
      #gem_index = 
      #Gem::Indexer.stub(:new).and_return(gem_index)
      Gem::Indexer.should_receive(:new).with("#{APP_ROOT}/public").and_return(gem_index)
      post "/push", :file => local_file
    end
  end
end