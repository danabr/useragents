# encoding: utf-8
require 'yaml'

def debug(str)
  $stderr.puts str if $DEBUG
end

def make_patterns(str)
  patterns = []
  str.length.downto(2) do |length|
    offset = 0
    while offset + length <= str.length
      pattern =  Regexp.new(Regexp.escape(str[offset, length]), "i")
      patterns << pattern
      offset += 1
    end
  end
  patterns.uniq
end

def load_strings
  lines = []
  $stdin.each do |line|
    lines << line.chomp
  end
  lines
end

agents = load_strings.sort {|a, b| a.length <=> b.length}
debug "Loaded #{agents.length} agents"
matching_agent = agents.shift
debug "Matching against: #{matching_agent.inspect}"
patterns = make_patterns(matching_agent)
debug "Found #{patterns.size} patterns"

index = 0
while !patterns.empty? && index < agents.size
  agent = agents[index]
  patterns = patterns.select {|pattern| pattern.match(agent) }
  index += 1
end

debug "Found #{patterns.length} matchers"
debug "Best matches: " + patterns.inspect

$stdout.print YAML.dump(patterns.map {|p| p.source })