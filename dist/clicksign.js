// Generated by CoffeeScript 1.8.0
(function() {
  var attach_element, clean_height, clean_host, clean_width, configure, create_iframe, defaults, document, min, min_or_defaults, url_for;

  document = this.document;

  defaults = function(value, defaults) {
    return value || defaults;
  };

  min = function(value, min) {
    if (value < min) {
      return min;
    } else {
      return value;
    }
  };

  min_or_defaults = function(d, m) {
    return function(value) {
      return min(defaults(value, d), m);
    };
  };

  clean_height = min_or_defaults(300, 100);

  clean_width = min_or_defaults(300, 100);

  clean_host = function(source) {
    return defaults(source, "https://widget.clicksign-demo.com");
  };

  url_for = function(host, key, email) {
    return "" + host + "/documents/" + key + "?email=" + email;
  };

  create_iframe = function(source, height, width) {
    var iframe;
    iframe = document.createElement("iframe");
    iframe.setAttribute('src', source);
    iframe.setAttribute('width', width);
    iframe.setAttribute('height', height);
    return iframe;
  };

  attach_element = function(base, element) {
    var target;
    target = document.getElementById(base);
    return document.body.insertBefore(element, target.nextSibling);
  };

  configure = function(options) {
    var base, email, height, host, iframe, key, source, width;
    height = clean_height(options.height);
    width = clean_width(options.height);
    host = clean_host(options.host);
    base = options.base;
    email = options.email;
    key = options.key;
    source = url_for(host, key, email);
    iframe = create_iframe(source, width, height);
    return attach_element(base, iframe);
  };

  this.clicksign || (this.clicksign = {
    configure: configure
  });

}).call(this);
