require 'fileutils'

class GemServer
  
  def call(env)
    request = Rack::Request.new(env)
    case request.path_info
    when "/push"
      upload_gem(request)
    else
      [200, {"Content-Type" => "text/html"}, ["we"]]
    end
  end
  
  private
  def upload_gem(request)
    return [500, {"Content-Type" => "text/html"}, [""]] unless request.post?
    file = request.params['file']
    return [400, {"Content-Type" => "text/html"}, [""]] if file.nil?
    
    FileUtils.mv file[:tempfile], "#{APP_ROOT}/public/gems/#{file[:filename]}"
    #return [400, {"Conten-Type" => "text/html"}, [""]] if request.params['file'].nil?
    
    [200, {"Content-Type" => "text/html"}, ["OK!"]]
  end
end