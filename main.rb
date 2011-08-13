# encoding: utf-8
require 'open3'
require 'fileutils'

def browser_filename(browser)
  browser.downcase.gsub(/\s+/, '')
end

def find_fingerprints
  puts "Detecting unique fingerprints"
  system("ruby findfingerprints.rb tmp/patterns/")
end

def find_patterns
  agent_files = Dir.glob("tmp/agents/*")
  agent_files.each do |agent_file|
    browser_name = agent_file.split("/").last
    print "\rFinding patterns for #{browser_name}".ljust(80)
    system("ruby findpatterns.rb < #{agent_file} > tmp/patterns/#{browser_name}.yaml")
  end
end

def get_agents
  File.open("tmp/browsers") do |file|
    file.each_line do |browser|
      browser.chomp!
      print "\rFetching #{browser} agents".ljust(80)
      path = "tmp/agents/" + browser_filename(browser)
      system("ruby getagents.rb \"#{browser}\" > #{path}")
    end
  end
end

def get_browsers
  system("ruby getbrowsers.rb > tmp/browsers")
end

step = (ARGV[0] || "0").to_i

if step <= 0
  FileUtils.rm_r("tmp", :force => true)
  FileUtils.mkdir_p(["tmp/agents", "tmp/patterns"])
end

get_browsers if step <= 1
get_agents if step <= 2
find_patterns if step <= 3
find_fingerprints if step <= 4