#!/usr/bin/env ruby

require_relative "../lib/projector"

begin
  Projector::Application.new(ARGV).run
rescue Errno::ENOENT => err
  abort "projector: #{err.message}"
rescue OptionParser::InvalidOption => err
  abort "projector: #{err.message}\nusage: TODO: Fill in usage"
end
