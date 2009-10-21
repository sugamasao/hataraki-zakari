require 'rubygems'
require 'sinatra'

get '/:filename' do
  xml = '<?xml version="1.0" encoding="utf-8"?>not found'
  if File.file? params[:filename]
    xml = File.read(params[:filename])
  end
  content_type :xml
  xml
end

