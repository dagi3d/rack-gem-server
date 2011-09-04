require 'rest_client'

exit if ARGV.size == 0

file = File.new(ARGV[0])
host = ARGV[1]

begin
  response = RestClient.post(host, :file => file)
  puts response.inspect
rescue Exception => e
  puts e.inspect
end

