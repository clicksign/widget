PROTOCOL = "https"
HOST = "widget.clicksign-demo.com"
WIDTH = { MIN: 600, DEFAULT: 800 }
HEIGHT = { MIN: 500, DEFAULT: 600 }

getElementById = (name) -> document.getElementById(name)
addEventListener = (callback) -> window.addEventListener("message", callback)

origin = (protocol, host) "#{protocol || PROTOCOL}://#{host || HOST}"
document_path = (k, e) -> "/documents/#{k}?email=#{e}&origin=#{location.origin}"

create_iframe = (source, width, height) ->
  min = (m) -> (v) -> if v < m then m else v
  normalize = (m, d) -> (v) -> min(m)(v || d)

  width ||= WIDTH.DEFAULT
  heidht ||= HEIGHT.DEFAULT

  normalize_width = normalize(WIDTH.MIN, WIDTH.DEFAULT)
  normalize_height = normalize(HEIGHT.MIN, HEIGHT.DEFAULT)

  iframe = document.createElement("iframe")
  iframe.setAttribute('src', source)
  iframe.setAttribute('width', normalize_width(width))
  iframe.setAttribute('height', normalize_height(height))
  iframe

attach_element = (container, element) ->
  target = getElementById(container)
  target.appendChild(element)

configure = (options) ->
  domain = domain_for(options.protocol, options.host)
  path = document_path(options.key, options.email)
  source = domain + path

  iframe = create_iframe(source, options.width, options.height)

  attach_element(options.container, iframe)

  callback = options.callback || ->
  addEventListener("message", options.callback || ->)

@clicksign ||= configure: configure
