require "colorize"

module Ymy
  INFO = ["INFO", :blue]
  WARN = ["WARN", :yellow]
  ERR = ["ERR", :red]

  def self.prt(p, l : String)
    puts "[#{p[0]}][#{Time.local.to_s("%H:%M:%S")}] #{l}"
  end
end
