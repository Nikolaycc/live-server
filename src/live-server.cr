require "http/server"
require "file_utils"
require "./log.cr"

if ARGV.size == 0
  puts "Usage:  live-server [file]\n\tlive-server [file] [-P port (default :8000)]\n\tlive-server --help\n\tlive-server -h".colorize(43, 124, 255)
  exit(0)
elsif ARGV[0] == "--help" || ARGV[0] == "-h"
  puts "Usage:  live-server [file]\n\tlive-server [file] [-P port (default :8000)]\n\tlive-server --help\n\tlive-server -h".colorize(43, 124, 255)
  exit(0)
end

file = File.open("#{FileUtils.pwd}/#{ARGV[0].to_s}") do |d|
  d.gets_to_end
end

Ymy.prt Ymy::INFO, "file: #{FileUtils.pwd}/#{ARGV[0].to_s}"

d = Dir.current
dir = ARGV[0] rescue d
path = Dir.exists?(dir) ? dir : Dir.exists?(File.join(d, dir)) ? File.join(d, dir) : d
listing = !!Dir.children(path).find { |x| x == "index.html" }
actual_path = listing ? File.join(path, "index.html") : path

server = HTTP::Server.new([
        HTTP::ErrorHandler.new,
        HTTP::LogHandler.new,
        HTTP::StaticFileHandler.new(path, directory_listing: !listing)]) do |context|
  context.response.content_type = "text/html"
  File.open(actual_path) { |file| IO.copy(file, context.response) }
end

case ARGV[1]
when "-P"
  port = ARGV.find { |x| x.to_i { 0 } > 0 }.tap { |x| ARGV.delete(x) }.to_s.to_i { 8000 }
  Ymy.prt Ymy::INFO, "Listening on http://127.0.0.1:#{port}"
  server.listen(port)
else
  Ymy.prt Ymy::INFO, "Listening on http://127.0.0.1:8000"
  server.listen(8000)
end
