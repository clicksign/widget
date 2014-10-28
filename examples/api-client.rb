require 'cgi'
require 'sinatra'
require 'haml'
require 'coffee_script'
require 'rest_client'
require 'json'
require 'ostruct'
require 'clicksign'

KEY = /(\h{8}-\h{4}-\h{4}-\h{4}-\h{12}|\h{4}-\h{4}-\h{4}-\h{4})/

configure do
  set :access_token, ENV['ACCESS_TOKEN']
  set :protocol, ENV['PROTOCOL'] || "https"
  set :host, ENV['HOST'] || "clicksign-demo.com"
  set :api_host, "api.#{settings.host}"
  set :widget_host, "widget.#{settings.host}"

  Clicksign.configure do |config|
    config.token = settings.access_token
    config.endpoint = "#{settings.protocol}://#{settings.api_host}"
  end
end

helpers do
  def materialize(tempname, tempfile)
    filename = "tmp/#{tempname}"
    File.open(filename, "wb") { |file| file.write(tempfile.read) }
    file = File.open(filename, "rb")

    yield(file)
  ensure
    File.delete(filename)
  end
end

# Index all documents related to access token
get "/" do
  @documents = Clicksign::Document.all.collect { |hash| hash['document'] }
  haml :index
end

# Upload a document
post "/" do
  name = params[:archive][:filename]
  temp = params[:archive][:tempfile]

  materialize(name, temp) do |file|
    @document = Clicksign::Document.create(file)
  end

  redirect to("/#{@document['key']}"), 303
end

# Show a specific document
get %r{/#{KEY}$} do |key|
  @document = Clicksign::Document.find(key)['document']
  haml :show
end

# Create signature list
post %r{/#{KEY}/list$} do |key|
  emails = params[:emails].each_line.collect { |line| line.chomp.split(",") }
  signers = emails.collect { |email, act| { email: email, act: act }}

  @document = Clicksign::Document.create_list(key, signers, false)['document']
  redirect to("/#{@document['key']}"), 303
end

# Show a document widget
get %r{/#{KEY}/widget$} do |key|
  @key = key
  @email = params[:email]

  haml :widget
end

post "/batches" do
  keys = params[:keys]
  @batch = Clicksign::Batch.create(keys)

  haml :batch
end
