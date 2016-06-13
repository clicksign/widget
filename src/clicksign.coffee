PROTOCOL = "https"
HOST = "widget.clicksign.com"
WIDTH = { MIN: 600, DEFAULT: 800 }
HEIGHT = { MIN: 500, DEFAULT: 600 }
TIMEOUT = 120000 # 2 minutes by default

window = @

getElementById = (name) -> document.getElementById(name)
createElement = (element) -> document.createElement(element)

callback_registered = false
addEventListener = (callback) ->
  return if callback_registered

  if window.addEventListener
    window.addEventListener('message', callback)
  else
    window.attachEvent('onmessage', callback)

  callback_registered = true

origin = location.origin || "#{location.protocol}//#{location.host}"

protocol_for = (protocol) -> (protocol || PROTOCOL) + "://"
host_for = (host) -> host || HOST
timeout_for = (timeout) -> timeout || TIMEOUT
path_for = (key) -> "/#{key}"
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
  timeout = timeout_for(options.timeout)
  path = path_for(options.key)
  query = query_for(options.signer)

  source = protocol + host + path + query

  iframe = create_iframe(source, options.width, options.height)

  attach_element(options.container, iframe)
  addEventListener(options.callback || ->)

  trigger_timeout = -> window.postMessage('timeout', origin)
  check_timeout = setTimeout(trigger_timeout, timeout)
  cancel_timeout = -> clearTimeout(check_timeout)
  addEventListener(cancel_timeout)

@clicksign ||=
  configure: configure
  version: "1.0.rc2"
