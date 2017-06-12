ENDPOINT = 'https://widget.clicksign.com'
WIDTH = '100%'
HEIGHT = '85vh'
STYLE = 'border: 1px solid #777; border-radius: 3px;'
DEFAULT_VERSION = '1'

window = @

params = (data = {}) ->
  options = {}
  options[k] = v for k, v of data
  options.origin ||= window.location.protocol + '//' + window.location.host

  ([k, encodeURIComponent(v)].join('=') for k, v of options).join('&')

Widget = (container, key, options) ->
  fn = => cb(arguments...) for cb in @callbacks

  @destroy = ->
    @container.removeChild(@iframe)

    if window.removeEventListener
      window.removeEventListener('message', fn)
    else
      window.detachEvent('onmessage', fn)

  @key = key
  @callbacks = options.callbacks || []
  @container = window.document.getElementById(container)

  @iframe = window.document.createElement('iframe')

  src = (options.endpoint || ENDPOINT) + '/' + key + '?' + params(options.signer) + '&v=' + (options.version || DEFAULT_VERSION)
  src += '&' + params(options.colors) if options.colors

  @iframe.setAttribute('src', src)
  @iframe.setAttribute('style', options.style || STYLE)

  @iframe.style.width = options.width || WIDTH
  @iframe.style.height = options.height || HEIGHT

  if window.addEventListener
    window.addEventListener('message', fn)
  else
    window.attachEvent('onmessage', fn)

  @container.appendChild(@iframe)
  @

create = (container, key, options = {}) ->
  new Widget(container, key, options)

window.clicksign =
  create: create
  version: '2.0-rc3'
