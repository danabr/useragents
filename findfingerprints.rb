# encoding: utf-8
require 'yaml'

def load_patterns(file)
  # [] guards against empty files
  YAML.load(File.read(file)) || []
end

patterns = {}
dir = ARGV[0]
files = Dir.glob(dir + "*.yaml")
files.each do |file|
  browser_name = File.basename(file, ".yaml")
  patterns[browser_name] = load_patterns(file)
end

occurences = Hash.new(0)
patterns.each do |k, v|
  v.each do |pattern|
    occurences[pattern] += 1
  end
end

duplicates = []
occurences.each do |pattern, occurences|
  if occurences > 1
    duplicates << pattern
  end
end

unidentifiable = []
patterns.each do |browser, browser_patterns|
  unique = browser_patterns - duplicates
  puts "#{browser}: " + unique.reverse.inspect
  if unique.empty?
    unidentifiable << browser
  end
end
puts "Unidentifable browsers (#{unidentifiable.size}): #{unidentifiable.join(", ")}"