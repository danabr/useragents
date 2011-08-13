# encoding: utf-8

require 'rubygems'
require 'mechanize'

url = "http://www.useragentstring.com/pages/" + $ARGV[0] + "/"
agent = Mechanize.new
page = agent.get(url)

agents = page.search(".//li").map {|ul| ul.search('.//a')[0].children[0].text }
print agents.join("\n")