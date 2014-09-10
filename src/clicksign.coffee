PROTOCOL = "https"
HOST = "widget.clicksign.com"
WIDTH = { MIN: 600, DEFAULT: 800 }
HEIGHT = { MIN: 500, DEFAULT: 600 }

getElementById = (name) -> document.getElementById(name)
addEventListener = (callback) -> window.addEventListener("message", callback)

options_for = (options) -> ("#{k}=#{v}" for k, v of options).join("&")
origin_for = (protocol, host) -> "#{protocol || PROTOCOL}://#{host || HOST}"
path_for = (key) -> "/documents/#{key}"
query_for = (signer = {}) -> "?origin=#{location.origin}&" + options_for(signer)

create_iframe = (source, width, height) ->
  min = (m) -> (v) -> if v < m then m else v
  normalize = (m, d) -> (v) -> min(m)(v || d)

  width ||= WIDTH.DEFAULT
  height ||= HEIGHT.DEFAULT

  normalize_width = normalize(WIDTH.MIN, WIDTH.DEFAULT)
  normalize_height = normalize(HEIGHT.MIN, HEIGHT.DEFAULT)

  iframe = document.createElement("iframe")
  iframe.setAttribute('src', source)
  iframe.setAttribute('width', normalize_width(width))
  iframe.setAttribute('height', normalize_height(height))
  iframe.setAttribute('style', 'border: 1px solid #999; border-radius: 3px;')
  iframe

attach_element = (container, element) ->
  target = getElementById(container)
  target.appendChild(element)

configure = (options) ->
  origin = origin_for(options.protocol, options.host)
  path = path_for(options.key)
  query = query_for(options.signer)
  source = origin + path + query

  iframe = create_iframe(source, options.width, options.height)

  attach_element(options.container, iframe)

  callback = options.callback || ->
  addEventListener("message", options.callback || ->)

@clicksign ||= configure: configure
