APP_ROOT = File.expand_path('.')

require File.expand_path('../gem_server', __FILE__)
run GemServer.new
=begin

run Rack::URLMap.new({
  "/"     => Rack::Directory.new("public"),
  "/push" => GemServer.new
})
=end