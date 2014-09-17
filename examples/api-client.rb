require 'sinatra'
require 'haml'
require 'coffee_script'
require 'rest_client'
require 'json'
require 'ostruct'

configure do
  set :access_token, ENV['ACCESS_TOKEN']
  set :protocol, ENV['PROTOCOL'] || "https"
  set :host, ENV['HOST'] || "clicksign-demo.com"
  set :api_host, "api.#{settings.host}"
  set :widget_host, "widget.#{settings.host}"
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

  def document(json)
    OpenStruct.new(json).tap do |document|
      list = OpenStruct.new(document.list)
      document.list = list

      signatures = document.list.signatures.collect { |s| OpenStruct.new(s) }
      list.signatures = signatures
    end
  end

  def api_domain
    "#{settings.protocol}://#{settings.api_host}"
  end

  def api_url(*path)
    ([api_domain, "v1", "documents"] + path).join("/")
  end

  def api_params(params = {})
    { access_token: settings.access_token }.merge(params)
  end

  def api_get_documents
    RestClient.get(api_url, params: api_params, accept: "json")
  end

  def api_get_document(key)
    RestClient.get(api_url(key), params: api_params, accept: "json")
  end

  def api_create_document(name, temp)
    materialize(name, temp) do |file|
      RestClient.post(api_url, api_params("document[archive][original]" => file), accept: "json")
    end
  end

  def api_create_list(key, signers)
    RestClient.post(api_url(key, 'list') + "?access_token=#{settings.access_token}", { signers: signers, skip_email: true }.to_json, content_type: "json", accept: "json")
  end

  def get_documents
    JSON[api_get_documents].collect { |r| document(r['document']) }
  end

  def get_document(key)
    document(JSON[api_get_document(key)]['document'])
  end

  def create_document(name, temp)
    document(JSON[api_create_document(name, temp)]['document'])
  end

  def create_list(key, signers)
    document(JSON[api_create_list(key, signers)]['document'])
  end
end

# Index all documents related to access token
get "/" do
  @documents = get_documents
  haml :index
end

# Upload a document
post "/" do
  name = params[:archive][:filename]
  temp = params[:archive][:tempfile]

  begin
    @document = create_document(name, temp)
  rescue
    redirect to("/"), 500
  else
    redirect to("/#{@document.key}"), 303
  end
end

# Show a specific document
get %r{/(\h{4}-\h{4}-\h{4}-\h{4})$} do |key|
  @document = get_document(key)
  haml :show
end

# Create signature list
post %r{/(\h{4}-\h{4}-\h{4}-\h{4})/list} do |key|
  emails = params[:emails].each_line.collect { |line| line.chomp.split(",") }
  signers = emails.collect { |email, act| { email: email, act: act }}

  begin
    @document = create_list(key, signers)
  rescue
    redirect to("/#{key}"), 500
  else
    redirect to("/#{@document.key}"), 303
  end
end

# Show a document widget
get %r{/(\h{4}-\h{4}-\h{4}-\h{4})/widget} do |key|
  @document = get_document(key)
  @email = params[:email]

  haml :widget
end
