ENDPOINT = 'https://widget.clicksign.com'
WIDTH = 800
HEIGHT = 600
STYLE = 'border: 1px solid #777; border-radius: 3px;'

window = @

params = (data = {}) ->
  options = {}
  options[k] = v for k, v of data
  options.origin = window.location.protocol + '//' + window.location.host

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
  @iframe.setAttribute('src', (options.endpoint || ENDPOINT) + '/' + key + '?' + params(options.signer))
  @iframe.setAttribute('width', options.width || WIDTH)
  @iframe.setAttribute('height', options.height || HEIGHT)
  @iframe.setAttribute('style', options.style || STYLE)

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
  version: '2.0-rc1'
