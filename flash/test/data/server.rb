require 'rubygems'
require 'sinatra'

get '/:filename' do
  xml = "not found"
  if File.file? params[:filename]
    xml = File.read(params[:filename])
  end
  content_type :xml
  xml
end

