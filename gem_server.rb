require 'fileutils'
require 'rubygems/user_interaction'
require 'rubygems/indexer'


class GemServer
  
  def call(env)
    request = Rack::Request.new(env)
    case request.path_info
    when "/"
      list_gems(request)
    when "/push"
      upload_gem(request)
    else
      [404, {"Content-Type" => "text/html"}, ["Page not found"]]
    end
  end
  
  private
  def gem_indexer
    Gem::Indexer.new("#{APP_ROOT}/public")
  end
  
  def upload_gem(request)
    return [500, {"Content-Type" => "text/html"}, ["Invalid method"]] unless request.post?
    
    file = request.params['file']
    return [400, {"Content-Type" => "text/html"}, ["No file was given"]] if file.nil?
    
    gem_format = Gem::Format.from_file_by_path(file[:tempfile])
    return [400, {"Content-Type" => "text/html"}, ["Invalid gem"]] if gem_format.nil?
    
    dst_dir = "#{APP_ROOT}/public/gems"
    FileUtils.mkdir(dst_dir) unless File.exists?(dst_dir)
    FileUtils.mv file[:tempfile], "#{dst_dir}/#{file[:filename]}"
    
    gem_indexer.generate_index
        
    [200, {"Content-Type" => "text/html"}, ["OK!"]]
  end
  
  def list_gems(request)
    out = <<-HTML
    <html>
      <body>
      <ul>
        #{gem_indexer.gem_file_list.map {|gem| '<li>' + File.basename(gem) + '</li>'}.join}
      </ul>
      </body>
    </html>
    HTML

    [200, {"Content-Type" => "text/html"}, [out]]
  end
  
end