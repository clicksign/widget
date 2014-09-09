WIDTH_MIN = 600
WIDTH_DEFAULT = 800
HEIGHT_MIN = 500
HEIGHT_DEFAULT = 600
PROTOCOL_DEFAULT = "https"
HOST_DEFAULT = "widget.clicksign-demo.com"
ORIGIN = @location.origin
DOCUMENT = @document

defaults = (d) -> (v) -> v || d

protocol_for = defaults(PROTOCOL_DEFAULT)
host_for = defaults(HOST_DEFAULT)

domain_for = (p, h) -> "#{protocol_for(p)}://#{host_for(h)}"
document_path = (k, e) -> "/documents/#{k}?email=#{e}&origin=#{ORIGIN}"

create_iframe = (source, width, height) ->
  min = (m) -> (v) -> if v < m then m else v
  normalize = (m, d) -> (v) -> min(m)(defaults(d)(v))

  normalize_height = normalize(HEIGHT_DEFAULT, HEIGHT_DEFAULT)
  normalize_width = normalize(WIDTH_DEFAULT, WIDTH_DEFAULT)

  iframe = document.createElement("iframe")
  iframe.setAttribute('src', source)
  iframe.setAttribute('width', normalize_width(width))
  iframe.setAttribute('height', normalize_height(height))
  iframe

attach_element = (container, element) ->
  target = DOCUMENT.getElementById(container)
  target.appendChild(element)

configure = (options) ->
  domain = domain_for(options.protocol, options.host)
  path = document_path(options.key, options.email)

  iframe = create_iframe(domain + path, options.width, options.height)

  attach_element(options.container, iframe)

  callback = options.callback || ->
  window.addEventListener("message", callback)

@clicksign ||= configure: configure
