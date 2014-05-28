require 'rubygems'
require 'mongo'
require 'twitter'

require_relative 'config'
require_relative 'twitter_archiver'

TAGS.each do |tag|
  archiver = TwitterArchiver.new(tag)
  archiver.update
end
