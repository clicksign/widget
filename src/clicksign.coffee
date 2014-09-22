PROTOCOL = "https"
HOST = "widget.clicksign.com"
WIDTH = { MIN: 600, DEFAULT: 800 }
HEIGHT = { MIN: 500, DEFAULT: 600 }

window = @

getElementById = (name) -> document.getElementById(name)
createElement = (element) -> document.createElement(element)
addEventListener = (callback) ->
  if window.addEventListener
    window.addEventListener('message', callback)
  else
    window.attachEvent('onmessage', callback)

origin = location.origin || "#{location.protocol}//#{location.host}"

protocol_for = (protocol) -> (protocol || PROTOCOL) + "://"
host_for = (host) -> host || HOST
path_for = (key) -> "/documents/#{key}"
query_for = (signer = {}) ->
  options = { origin: origin }
  options[k] = v for k, v of signer
  "?" + ("#{k}=#{encodeURIComponent(v)}" for k, v of options).join("&")

create_iframe = (source, width, height) ->
  min = (m) -> (v) -> if v < m then m else v
  normalize = (m, d) -> (v) -> min(m)(v || d)

  normalize_width = normalize(WIDTH.MIN, WIDTH.DEFAULT)
  normalize_height = normalize(HEIGHT.MIN, HEIGHT.DEFAULT)

  iframe = createElement("iframe")
  iframe.setAttribute('src', source)
  iframe.setAttribute('width', normalize_width(width))
  iframe.setAttribute('height', normalize_height(height))
  iframe.setAttribute('style', 'border: 1px solid #777; border-radius: 3px;')
  iframe

attach_element = (container, element) ->
  target = getElementById(container)
  target.appendChild(element)

configure = (options) ->
  protocol = protocol_for(options.protocol)
  host = host_for(options.host)
  path = path_for(options.key)
  query = query_for(options.signer)

  source = protocol + host + path + query

  iframe = create_iframe(source, options.width, options.height)

  attach_element(options.container, iframe)
  addEventListener(options.callback || ->)

@clicksign ||=
  configure: configure
  vesion: 1
