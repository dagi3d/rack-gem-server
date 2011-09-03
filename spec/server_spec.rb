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
    let(:invalid_local_file) {Rack::Test::UploadedFile.new(File.expand_path('../invalid-gem.0.0.1.gem', __FILE__))}
    let(:gem_indexer) { mock(Gem::Indexer) }
  
    
    before do
      gem_indexer.stub!(:generate_index).and_return(true)
      Gem::Indexer.stub(:new).and_return(gem_indexer)
    end
    
    it "should not respond to post /push when no file is given" do
      post "/push"
      last_response.should_not be_ok
    end
  
    it "should respond to post /push when a gile is given" do
      post "/push", :file => local_file
      last_response.should be_ok
    end
    
    it "should raise an exception when the uploaded file is not a valid gem" do
      post "/push", :file => invalid_local_file
      last_response.should_not be_ok
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
      Gem::Indexer.should_receive(:new).with("#{APP_ROOT}/public")
      gem_indexer.should_receive(:generate_index)
      post "/push", :file => local_file
    end
  end
end