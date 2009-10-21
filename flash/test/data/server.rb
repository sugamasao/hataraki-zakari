require 'rubygems'
require 'sinatra'

get '/:filename' do
  xml = '<?xml version="1.0" encoding="utf-8"?>not found'
  path = File.dirname(__FILE__) + '/' + params[:filename]
  puts path
  if File.file? path
    xml = File.read(path)
  end
  content_type :xml
  xml
end

