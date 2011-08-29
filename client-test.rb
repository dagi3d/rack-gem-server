require 'rest_client'

return if ARGV.size == 0

file = File.new(ARGV[0])
host = ARGV[1]

response = RestClient.post(host, :file => file)
puts response

