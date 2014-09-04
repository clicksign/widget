require 'sinatra'
require 'haml'
require 'coffee_script'
require 'rest_client'
require 'json'
require 'ostruct'
require 'pry'

configure do
  set :access_token, ENV['ACCESS_TOKEN']
  set :api_host, ENV['API_HOST'] || "https://api.clicksign-demo.com"
  set :widget_url, ENV['WIDGET_URL'] || "http://desk.clicksign-demo.com/widget"
end

helpers do
  def document(json)
    OpenStruct.new(json).tap do |document|
      list = OpenStruct.new(document.list)
      document.list = list

      signatures = document.list.signatures.collect { |s| OpenStruct.new(s) }
      list.signatures = signatures
    end
  end

  def api_url(*path)
    ([settings.api_host, "v1", "documents"] + path).join("/")
  end

  def api_params(params = {})
    { access_token: settings.access_token }.merge(params)
  end

  def get_documents
    RestClient.get(api_url, params: api_params, accept: "json")
  end

  def get_document(key)
    RestClient.get(api_url(key), params: api_params, accept: "json")
  end

  def create_document(file)
    RestClient.post(api_url, api_params("document[archive][original]" => file), accept: "json")
  end
end

# Index all documents related to access token
get "/" do
  @documents = JSON[get_documents].collect { |record| document(record['document']) }

  haml :index
end

# Upload a document
post "/" do
  filename = "tmp/#{params[:archive][:filename]}"
  filetemp = params[:archive][:tempfile]
  File.open(filename, "wb") { |file| file.write(filetemp.read) }

  begin
    file = File.open(filename, "rb")
    @document = document(JSON[create_document(file)]['document'])
  rescue
    redirect to("/"), 500
  else
    redirect to("/#{@document.key}"), 303
  ensure
    File.delete(filename)
  end
end

# Show a specific document
get %r{/(\h{4}-\h{4}-\h{4}-\h{4})} do |key|
  @document = document(JSON[get_document(key)]['document'])

  haml :show
end

# Show a document widget
post "/widget" do
  haml :widget
end
