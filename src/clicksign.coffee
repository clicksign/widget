document = @document

defaults = (value, defaults) -> value || defaults
min = (value, min) -> if value < min then min else value
min_or_defaults = (d, m) -> (value) -> min(defaults(value, d), m)

clean_height = min_or_defaults(300, 100)
clean_width = min_or_defaults(300, 100)
clean_host = (source) -> defaults(source, "https://widget.clicksign-demo.com")

url_for = (host, key, email, origin) -> "#{host}/documents/#{key}?email=#{email}&origin=#{origin}"

create_iframe = (source, height, width) ->
  iframe = document.createElement("iframe")

  iframe.setAttribute('src', source)
  iframe.setAttribute('width', width)
  iframe.setAttribute('height', height)

  iframe

attach_element = (base, element) ->
  target = document.getElementById(base)
  document.body.insertBefore(element, target.nextSibling)

configure = (options) ->
  height = clean_height(options.height)
  width = clean_width(options.height)
  host = clean_host(options.host)

  base = options.base
  email = options.email
  key = options.key

  source = url_for(host, key, email, window.location.origin)
  iframe = create_iframe(source, width, height)

  attach_element(base, iframe)

  callback = options.callback || ->
  window.addEventListener("message", callback)

@clicksign ||= configure: configure
