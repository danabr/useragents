# encoding: utf-8

require 'rubygems'
require 'mechanize'

url = "http://www.useragentstring.com/pages/All/"
agent = Mechanize.new
page = agent.get(url)

browsers = page.search("//h3").map do |h3|
  if h3.children.size == 2
    h3.children[1].text.downcase
  elsif h3.attributes["style"]
    nil
  else
    h3.children[0].text.downcase
  end
end
browsers.compact!
browsers.sort!
$stderr.puts "Found #{browsers.size} browsers"
$stdout.print browsers.join("\n")