requirejs.config
  shim:
    jquery: 
      exports: 'jQuery'
    materialize:
      deps: [
        'jquery'
        'hammer'
      ]
      exports: 'Materialize'
    preloader:
      deps: [
        'jquery'
      ]
      exports: 'Preloader'
  paths:
    preloader: [
      '/javascripts/preloader'
    ]
    materialize: [
      'https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.6/js/materialize.min'
      '/lib/Materialize/dist/js/materialize.min'
    ]
    jquery: [
      'https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min'
      '/lib/jquery/dist/jquery.min'
    ]
    socketio: [
      'https://cdn.socket.io/socket.io-1.4.5'
      '/socket.io/socket.io'
    ]
    moment: [
      'https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.13.0/moment-with-locales.min'
      'https://cdn.jsdelivr.net/momentjs/2.13.0/moment-with-locales.min'
      '/lib/moment/min/moment-with-locales.min'
    ]
    mootools: [
      'https://ajax.googleapis.com/ajax/libs/mootools/1.6.0/mootools.min'
      'https://cdn.jsdelivr.net/mootools/1.5.0/mootools-core-compat.min'
      '/lib/mootools/dist/mootools-core.min'
    ]
    swfobject: [
      'https://ajax.googleapis.com/ajax/libs/swfobject/2.2/swfobject'
      'https://cdn.jsdelivr.net/swfobject/2.2/swfobject'
      '/lib/swfobject/swfobject/swfobject'
    ]
    hammer: [
      'https://cdnjs.cloudflare.com/ajax/libs/hammer.js/2.0.8/hammer'
      '/lib/hammerjs/hammer'
    ]
  test: 'app/test'
  methods: 'app/methods'
  savelocal: 'app/savelocal'

require [
  'socketio'
  'jquery'
  'preloader'
  'materialize'
]

